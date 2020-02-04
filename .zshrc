########### my default setting ###########

export PATH=${PATH}:/usr/local/bin
export PATH=${PATH}:${HOME}/go/bin

alias v='vim'
alias vi='vim'
alias g='git'
alias k='kubectl'
alias kx='kubectx'
alias kn='kubens'
alias ls='ls -F'
alias la='ls -a'
alias ll='ls -la'
alias mkdir='mkdir -p'
alias ..='cd ../'
alias ...='cd ../..'
alias ....='cd ../../..'
alias shfmt='shfmt -i 2 -ci -s'

. ${HOME}/.individual.zsh
. ${HOME}/.organization.zsh

########### zsh ###########

export HISTSIZE=1000000
export SAVEHIST=10000000



########### prezto ###########

#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...
fpath=(/usr/local/share/zsh-completions $fpath)



########### fzf ###########

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'





########### peco ###########

function peco-select-history() {
 BUFFER=$(\history -n -r 1 | peco --query "$LBUFFER")
 CURSOR=$#BUFFER
 zle clear-screen
}
zle -N peco-select-history
bindkey '^z' peco-select-history



########### docker ###########

function rm-docker-image {
	docker rmi `docker images | fzf | awk '{print $3}'`
}

function rm-docker-image-all {
	docker rmi $(docker images -q) -f
}

function rm-docker-process {
	docker rm `docker ps -a -q`
}

function stop-docker-container {
	docker stop `docker ps | fzf | awk '{print $1}'`
}

function exec-docker-bash {
	local TARGET_SHELL=$1
	docker exec -it `docker ps | fzf | awk '{print $1}'` /bin/${TARGET_SHELL:-sh}
}

function docker-images {
	docker images
}

function docker-stop {
	docker stop `docker ps -a -q`
}

function docker-logs {
	docker logs `docker ps | fzf | awk '{print $1}'`
}
function docker-run-daemon {
	docker images | fzf | awk '{print $1":"$2}' | xargs -I{} docker run -d {}
}

function docker-run-foreground {
	docker images | fzf | awk '{print $1":"$2}' | xargs -I{} docker run {}
}

function docker-build {
	docker build -t $1 .
}

function docker-push {
	docker images | fzf | awk '{print $1}' | xargs -I{} docker push {}
}

alias rmi='rm-docker-image'
alias rmia='rm-docker-image-all'
alias drm='rm-docker-process'
alias de='exec-docker-bash'
alias ds='stop-docker-container'
alias di='docker-images'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias dst='docker-stop'
alias dl='docker-logs'
alias drd='docker-run-daemon'
alias drf='docker-run-foreground'
alias db='docker-build'
alias dp='docker-push'


########### kubectl ###########

function get-kube-resources {
	fzf << EOS
pods
deployments
services
ingresses
configmaps
daemonsets
clusterrolebindings
clusterroles
cronjobs
customresourcedefinition
endpoints
events
horizontalpodautoscalers
jobs
limitranges
namespaces
nodes
persistentvolumeclaims
persistentvolumes
replicasets
rolebindings
roles
secrets
serviceaccounts
statefulsets
EOS
}

function get-kube-service-name {
	echo `kubectl get svc | fzf --height 40% --layout=reverse --border | awk '{print $1}'`
}

function get-pod-name {
	echo `kubectl get pods | sed -e 1d | fzf --height 40% --layout=reverse --border | awk '{print $1}'`
}

function get-container-name-from-pod-name {
	local POD_NAME=$1
	echo `kubectl get pods ${POD_NAME} -o jsonpath="{.spec.containers[*].name}" | tr -s '[[:space:]]' '\n' | sort | uniq | fzf --height 40% --layout=reverse --border`
}

function kube-get-anything {
	kubectl get `get-kube-resources`
}


function kube-get-target {
	local TARGET=$1
	local OPTION_ARG=$2
	case "${TARGET}" in
		p)
			TARGET=po
			;;
		d)
			TARGET=deploy
			;;
		s)
			TARGET=svc
			;;
		*)
			TARGET=po
			;;
	esac
	kubectl get ${TARGET} ${OPTION_ARG}
}

function kube-describe-anything {
	local TARGET=`get-kube-resources`
	kubectl describe $TARGET $(kubectl get $TARGET | sed -e 1d | fzf --height 40% --layout=reverse --border | awk '{print $1}')
}

function kube-exec-container-in-pod {
	local POD_NAME=`get-pod-name`
	local CONTAINER_NAME=`get-container-name-from-pod-name ${POD_NAME}`
	local SELECT_SHELL=`echo 'bash\nsh' | fzf --height 40% --layout=reverse --border`
	kubectl exec -it ${POD_NAME} --container ${CONTAINER_NAME} -- /bin/${SELECT_SHELL}
}

function kube-logs {
	local POD_NAME=`get-pod-name`
	local CONTAINER_NAME=`get-container-name-from-pod-name ${POD_NAME}`
	kubectl logs ${POD_NAME} --container ${CONTAINER_NAME} -f
}

function kube-logs-all {
	local POD_NAME=`get-pod-name`
	local CONTAINER_NAME=`get-container-name-from-pod-name ${POD_NAME}`
	#local PODS=`${POD_NAME} | fzf | awk '{print $1}' | awk -F'-' '{print $2}' | xargs -I{} echo {}`
	echo `echo ${POD_NAME} | awk '{print $1}' | awk -F'-' '{print $2}' | xargs -I{} grep kubectl get po {}`
	# kubectl logs ${POD_NAME} --container ${CONTAINER_NAME} -f
}

function kube-forward {	
	local SERVICE_NAME=`get-kube-service-name`
	local SERVICE_PORT=`kubectl get svc ${SERVICE_NAME} -o jsonpath="{.spec.ports[*].port}"`
	local LOCAL_PORT

	echo -n 'Enter local port: '
	read LOCAL_PORT

	kubectl port-forward svc/${SERVICE_NAME} ${LOCAL_PORT}:${SERVICE_PORT} > /dev/null 2>&1 &
}

function kube-pkill-forward {
	pkill -f 'kubectl port-forward svc/'
}

function kube-delete-anything {
	local RESOURCES=`get-kube-resources`
	local -a TARGETS=(`kubectl get ${RESOURCES} | sed -e 1d | fzf-settings-multi | awk '{print $1}'`) 

	for TARGET in ${TARGETS}; do
		kubectl delete ${RESOURCES} ${TARGET}
	done
}

function kube-apply-file {
	kubectl apply -f $1
}

function get-current-context {
	echo `kubectl config view current -o json | jq -r '."current-context"'`
}

function get-current-namespace {
	local CURRENT_CONTEXT=`get-current-context`
	kubectl config view current -o json | jq -r '.contexts[] | select (.name=="'$CURRENT_CONTEXT'") | .context.namespace'
}

function kube-show-current-configs {
	echo -e '\e[46;1;4mCurrent Context: '`get-current-context`' \e[m'
	echo -e '\e[46;1;4mCurrent Namespace: '`get-current-namespace`' \e[m'
}

function kube-set-current-configs-in-prompt {
	local CURRENT_CONTEXT=`echo "${$(get-current-context):0:12}"`
	local CURRENT_NAMESPACE=`echo "${$(get-current-namespace):0:12}"`
	
	if [ $CURRENT_NAMESPACE = "null" ]; then
		CURRENT_NAMESPACE="default"
	fi

	RPROMPT="%F{1:31}[`echo "$CURRENT_CONTEXT/$CURRENT_NAMESPACE"`]%f"
}

function remove-right-prompts {
	RPROMPT=""
}

function kube-run-po {
	kubectl run nginx --image nginx --restart Never --dry-run -o yaml
}

alias kg='kube-get-target'
alias kga='kube-get-anything'
alias kd='kube-describe-anything'
alias kdl='kube-delete-anything'
alias kec='kube-exec-container-in-pod'
alias kl='kube-logs'
alias kf='kube-forward'
alias kfka='kube-pkill-forward'
alias ka='kube-apply-file'
alias kcc='kube-show-current-configs'
alias kcp='kube-set-current-configs-in-prompt'
alias krp='kube-run-po'
alias rrp='remove-right-prompts'




