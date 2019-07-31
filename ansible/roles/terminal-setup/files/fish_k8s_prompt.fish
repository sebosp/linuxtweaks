function fish_k8s_prompt
  # Use this var to control display of the K8S prompt.
  if test "$K8S_PS1_SHOW" = "1"
    if test (math $K8S_PROMPT_TTL + $K8S_LAST_PROMPT_CHECK) -le (date +'%s')
      # For AWS EKS the context has a lot of colon separated data
      # Remove the first 4 colon separated fields
      # When the context is the domain, I find it handy to remove the last
      # 2 domain zones (eg .company.com)
      set -gx K8S_LAST_PROMPT_CHECK (math (date +'%s') + $K8S_PROMPT_TTL)
      set -gx K8SCTX (kubectl config current-context|cut -d: -f4-|rev|cut -d. -f3-|rev 2>/dev/null)
      set -gx K8SNS (kubectl config view -o json|jq ".contexts | map(select(.name| contains(\"$K8SCTX\")))[0]|.context.namespace" -r|cut -c-16)
      if test $status -gt 0
        set -gx K8S_LAST_CTX_PROMPT_CHECK (date +'%s')
        set -gx K8SCTX ""
      end
    end
    if test "$K8SNS" = "null"
     set -gx K8SNS "default"
    end
    if test  "$K8SNS" = "kube-system"; or string match -qr "prod" $K8SNS
      set_color red
    else
      set_color blue
    end
    echo -n "$K8SNS"
    set_color green
    echo -n "[$K8SCTX]"
  end
end

function fish_aws_role_prompt
  # Use this var to control display of the K8S prompt.
  if [ "1" = "$AWS_PS1_SHOW" ]
    if [ -z "$AWS_PROMPT_TTL" ]
      set -gx AWS_PROMPT_TTL 15
    end
    if [ -z "$AWS_LAST_PROMPT_CHECK" ]
      set -gx AWS_LAST_PROMPT_CHECK 1
    end
    if [ (math $AWS_PROMPT_TTL + $AWS_LAST_PROMPT_CHECK) -le (date +'%s') ]
      set -gx AWSROLE (aws sts get-caller-identity|grep '"Arn"'|cut -d'"' -f4|cut -d/ -f2|sed 's/role//ig;s/aws//ig;s/^[_-]*//g;s/[_-]*//g')
      set -gx AWS_LAST_PROMPT_CHECK (date +'%s')
    end
    if [ "x" != "x$AWSROLE" ]
      printf -- '%s' "$AWSROLE"
    end
  end
end
