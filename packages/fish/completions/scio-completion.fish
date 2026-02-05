function __parse_file_for_autocomplete
    set -l cmd (commandline -opc)
    set -l cur (commandline -ct)
    set -l prev (commandline -poc)

    set -l FILE "$HOME/scio-cmd/$argv[1].py.args"

    if test -f "$FILE"
        set -l positional_args (jq -r 'if .positional_args? then .positional_args else empty end' "$FILE")
        set -l all_args (jq -r 'if .all_args? then .all_args else empty end' "$FILE")
        set -l action_args (jq -r '.action_args | keys[]?' "$FILE")

        if test -n "$positional_args"; and test "$argv[1]" = "$prev[-1]"
            complete -C"$positional_args" -f
        else if contains "$prev[-1]" $action_args
            set -l options (jq -r --arg prev "$prev[-1]" '.[$prev]' "$FILE")
            if test -n "$options"
                complete -C"$options" -f
            end
        else if test -n "$all_args"
            complete -C"$all_args" -f
        end
    end
end

function __scio_completions
    set -l cmd (commandline -opc)
    set -l cur (commandline -ct)

    set -l commands "install build test run_local escrud test_admin_access test_api_token test_confluence_webhook test_github_webhook test_jira_webhook test_qe_access test_slack_webhook test_teams_webhook test_elastic_runner e2e_test cloud_sql deploy setup admin_actions setup_scio_access config_util deploy_scio_apps upgrade delete_documents logs_finder internal_actions run_docstore_reader sensitive_log_reader create_english_words_dataset people_graph_viz secret_store build_version clear_datasource elastic_cost full_crawl branch pull commit push hash_pii hash_string pralaya search chat public_chat"

    switch (count $cmd)
        case 1
            complete -C"$commands" -f
        case 2
            switch $cmd[2]
                case build test
                    complete -d -f
                case '*'
                    __parse_file_for_autocomplete $cmd[2]
            end
        case '*'
            __parse_file_for_autocomplete $cmd[2]
    end
end

complete -c scio -f -a '(__scio_completions)'

