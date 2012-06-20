function my_git_prompt_info() {
    echo `~/bin/scm_status.py`
  }

PROMPT=$'%B%U%~%b%u $(my_git_prompt_info)\n%k%n@%U%m%u > '
RPROMPT=$'%B%(?,%T,%{\e[31m%}_%?_ %{\e[0m%})%b - %h'
PROMPT2=$'%{\e[35m%}%_> %{\e[0m%}'
PROMPT3=$'%{\e[33m%}?# %{\e[0m%}'
PROMPT4=$'%{\e[32m%}+ %{\e[0m%}'


