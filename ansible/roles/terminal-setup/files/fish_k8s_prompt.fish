function ff
    if [ -z "$1" ]
      echo "Missing search argument" 1>&2
      return
   end
   find . -type f -name '*.yaml' -o -name '*.yml' -o -name '*.json' -o -name '*.py' -o -name '*.tf*' -exec grep -Hi "$1" {} \;
end

function fish_k8s_server_prompt
  # Use this var to control display of the K8S prompt.
  if [ "1" = "$K8S_PS1_SHOW" ]
    if [ -z "$K8S_PROMPT_TTL" ]
      export K8S_PROMPT_TTL=15
    end
    if [ -z "$K8S_LAST_CTX_PROMPT_CHECK" ]
      export K8S_LAST_CTX_PROMPT_CHECK=1
    end
    if [ (math $K8S_PROMPT_TTL + $K8S_LAST_CTX_PROMPT_CHECK) -le (date +'%s') ]
      export K8SCTX=(kubectl config current-context|cut -d: -f4- 2>/dev/null)
      export K8S_LAST_CTX_PROMPT_CHECK=(date +'%s')
    end
    if [ -z "$K8SCTX" ]
      export K8SCTX="NONE"
    end
    if [ "x" != "x$K8SCTX" ]
      printf -- '%s' "$K8SCTX"
    end
  end
end

function fish_k8s_ns_prompt
  # Use this var to control display of the K8S prompt.
  if [ "1" = "$K8S_PS1_SHOW" ]
    if [ -z "$K8S_PROMPT_TTL" ]
      export K8S_PROMPT_TTL=15
    end
    if [ -z "$K8S_LAST_NS_PROMPT_CHECK" ]
      export K8S_LAST_NS_PROMPT_CHECK=1
    end
    if [ (math $K8S_PROMPT_TTL + $K8S_LAST_NS_PROMPT_CHECK) -le (date +'%s') ]
      export K8SCTX=(kubectl config current-context 2>/dev/null)
      export K8SNS=(kubectl config view -o json|jq ".contexts | map(select(.name| contains(\"$K8SCTX\")))[0]|.context.namespace" -r|cut -c-16)
      export K8S_LAST_NS_PROMPT_CHECK=(date +'%s')
    end
    if [ "null" = "$K8SNS" ]
      export K8SNS="default"
    end
    if [ "x" != "x$K8SNS" ]
      if [ "kube-system" = "$K8SNS" ]; or string match -qr "prod" $K8SNS
          set_color red
      end
      printf -- '%s' "$K8SNS"
    end
  end
end

function fish_aws_role_prompt
  # Use this var to control display of the K8S prompt.
  if [ "1" = "$AWS_PS1_SHOW" ]
    if [ -z "$AWS_PROMPT_TTL" ]
      export AWS_PROMPT_TTL=15
    end
    if [ -z "$AWS_LAST_PROMPT_CHECK" ]
      export AWS_LAST_PROMPT_CHECK=1
    end
    if [ (math $AWS_PROMPT_TTL + $AWS_LAST_PROMPT_CHECK) -le (date +'%s') ]
      export AWSROLE=(aws sts get-caller-identity|grep '"Arn"'|cut -d'"' -f4|cut -d/ -f2|sed 's/role//ig;s/aws//ig;s/^[_-]*//g;s/[_-]*//g')
      export AWS_LAST_PROMPT_CHECK=(date +'%s')
    end
    if [ "null" = "$AWSROLE" ]
      export K8SNS="N/A"
    end
    if [ "x" != "x$AWSROLE" ]
      printf -- '%s' "$AWSROLE"
    end
  end
end

function fish_k8s_prompt
    # Placeholder matches the name of the file to force loading the fish k8s prompt
end
