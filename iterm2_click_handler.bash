#!/usr/bin/env bash
#!/bin/bash
# OPEN ITERM ON CLICK REF: https://stackoverflow.com/questions/43077713/iterm2-open-file#43078186
# iTerm2 > Profiles > Adv -> Semantic History > Run command:
# /usr/bin/env bash /Users/user.name/_/clis/guake_intuivo_cli/iterm2_click_handler.bash \1 \2 \3 \4 \5


# DEBUG
echo "
Start
echo 0:$0
echo 1:$1
echo 2:$2
echo 3:$3
echo 4:$4
echo 5:$5
echo 6:$6
echo 7:$7
"  >> "${HOME}/iterm2_click_handler.log"
this_script="${0}"
file="${1}"
line="${2}"
text_before_click="${3}"
text_after_click="${4}"
working_folder="${5}"

if [ -z ${working_folder} ] ; then
{
  file="${1}"
  line=1
  text_before_click="${2}"
  text_after_click="${3}"
  working_folder="${4}"
}
fi

# DEBUG
echo "
file="${file}"
line="${line}"
text_before_click="${text_before_click}"
text_after_click="${text_after_click}"
working_folder="${working_folder}"
"  >> "${HOME}/iterm2_click_handler.log"
# /usr/local/bin/pstorm "${file}:${line}"
# /usr/local/bin/nano +${line} "${file}"
# /usr/local/bin/subl -g "${file}:${line}"
echo "
Calling iterm2_quick_open_file_opener
${HOME}/_/clis/guake_intuivo_cli/iterm2_quick_open_file_opener \"${file}:${line}\" \"run_command\" \"${working_folder}\""  >>"${HOME}/iterm2_click_handler.log"
"${HOME}/_/clis/guake_intuivo_cli/iterm2_quick_open_file_opener" "${file}:${line}" "run_command" "${working_folder}" >>"${HOME}/iterm2_click_handler.log"
# "${HOME}/_/clis/guake_intuivo_cli/iterm2_quick_open_file_opener" "${file}:${line}" "run_command" "${working_folder}" "${text_before_click}" "${text_after_click}" >>"${HOME}/iterm2_click_handler.log"

exit 0
