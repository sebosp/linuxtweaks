#compdef ff
ff() {
    if [[ -z "$1" ]]; then
		>&2 echo "Missing search argument"
                return
	fi
	find . -type f -name '*.yaml' -o -name '*.yml' -o -name '*.json' -o -name '*.py' -o -name '*.tf*' -exec grep -Hi "$1" {} \;
}

__k8s_server_prompt ()
{
  # Use this var to control display of the K8S prompt.
  if [[ "1" == "${K8S_PS1_SHOW}" ]]; then
    if [[ -z "$K8S_PROMPT_TTL" ]]; then
      export K8S_PROMPT_TTL=15
    fi
    if [[ -z "$K8S_LAST_PROMPT_CHECK" ]]; then
      export K8S_LAST_PROMPT_CHECK=1
    fi
    if [[ $(($K8S_PROMPT_TTL + $K8S_LAST_PROMPT_CHECK)) < $(date +'%s') ]]; then
      export K8SCTX=$(kubectl config current-context|cut -d: -f4- 2>/dev/null)
      export K8S_LAST_PROMPT_CHECK=$(date +'%s')
    fi
    if [[ -z "${K8SCTX}" ]]; then
      export K8SCTX="NONE"
    fi
    if [[ "x" != "x${K8SCTX}" ]]; then
      printf -- '%s' "${K8SCTX}"
    fi
  fi
}
__k8s_ns_prompt ()
{
  # Use this var to control display of the K8S prompt.
  if [[ "1" == "${K8S_PS1_SHOW}" ]]; then
    if [[ -z "$K8S_PROMPT_TTL" ]]; then
      export K8S_PROMPT_TTL=15
    fi
    if [[ -z "$K8S_LAST_PROMPT_CHECK" ]]; then
      export K8S_LAST_PROMPT_CHECK=1
    fi
    if [[ $(($K8S_PROMPT_TTL + $K8S_LAST_PROMPT_CHECK)) < $(date +'%s') ]]; then
      export K8SCTX=$(kubectl config current-context 2>/dev/null)
      export K8SNS=$(kubectl config view -o json|jq ".contexts | map(select(.name| contains(\"$K8SCTX\")))[0]|.context.namespace" -r|cut -c-16)
      export K8S_LAST_PROMPT_CHECK=$(date +'%s')
    fi
    if [[ "null" == "${K8SNS}" ]]; then
      export K8SNS="default"
    fi
    if [[ "x" != "x${K8SNS}" ]]; then
      printf -- '%s' "${K8SNS}"
    fi
  fi
}
__aws_role_prompt ()
{
  # Use this var to control display of the K8S prompt.
  if [[ "1" == "${AWS_PS1_SHOW}" ]]; then
    if [[ -z "$AWS_PROMPT_TTL" ]]; then
      export AWS_PROMPT_TTL=15
    fi
    if [[ -z "$AWS_LAST_PROMPT_CHECK" ]]; then
      export AWS_LAST_PROMPT_CHECK=1
    fi
    if [[ $(($AWS_PROMPT_TTL + $AWS_LAST_PROMPT_CHECK)) < $(date +'%s') ]]; then
        export AWSROLE=$(aws sts get-caller-identity|grep '"Arn"'|cut -d'"' -f4|cut -d/ -f2|sed 's/role//ig;s/aws//ig;s/^[_-]*//g;s/[_-]*//g')
      export AWS_LAST_PROMPT_CHECK=$(date +'%s')
    fi
    if [[ "null" == "${AWSROLE}" ]]; then
      export K8SNS="N/A"
    fi
    if [[ "x" != "x${AWSROLE}" ]]; then
      printf -- '%s' "${AWSROLE}"
    fi
  fi
}
