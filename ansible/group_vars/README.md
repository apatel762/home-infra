# group_vars

Each folder in here is named after one of the groups in the [Ansible inventory](../../hosts.ini) file.

When an Ansible play is being run for a group, every variable in these folders will be sourced. Multiple files are only used to organise things (it makes no functional difference whether the variables are in one big file or multiple smaller ones).

Important files are prefixed with an underscore.

## References

1. StackOverflow (November 23, 2020). "[Supplying different credentials per host for privilege escalation](https://stackoverflow.com/a/33179445)". *[Archived](https://web.archive.org/web/20221227163353/https://stackoverflow.com/questions/33155459/ansible-how-to-run-a-play-with-hosts-with-different-passwords)*. Retrieved December 27, 2022.
