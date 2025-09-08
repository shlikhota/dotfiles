# Offer AI subjects when completing the -m/--message arg to `git commit`
complete -c git \
  -n '__fish_seen_subcommand_from commit' \
  -s m -l message -r -f \
  -a '(_ai_commit_subjects)' \
  -d 'AI suggestion from staged diff'
