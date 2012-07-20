function my_git_prompt_info() {
  echo `~/bin/scm_status.py $terminfo[colors]`
}

function my_host_name() {
  if [ -n "${SSH_CLIENT+x}" ]
  then
    echo @${HOST}
  fi
}

PROMPT=$'%B%U%~%b%u $(my_git_prompt_info)\n%k%(!.%F{red}.)%n%f%U$(my_host_name)%u %(!.%F{red}.)>%f '
RPROMPT=$'%B%(?,%*,%{\e[31m%}_%?_ %{\e[0m%})%b - %h'
PROMPT2=$'%{\e[35m%}%_> %{\e[0m%}'
PROMPT3=$'%{\e[33m%}?# %{\e[0m%}'
PROMPT4=$'%{\e[32m%}+ %{\e[0m%}'

REPORTTIME=2
TIMEFMT="Real: %E User: %U System: %S Percent: %P Cmd: %J"
