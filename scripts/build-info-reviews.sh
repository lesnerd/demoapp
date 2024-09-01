#!/bin/bash

function allCommits() {
    local owner="$1"
    local repo="$2"
    local GH_TOKEN="$3"
    local output_file="$4"

    # Iterate over each commit in output_file
    jq -c '.[]' "$output_file" | while read -r commit_json; do
      commit_sha=$(echo "$commit_json" | jq -r '.revision')
      # echo "Processing commit: $commit_sha"
      pull_request_numbers=$(curl -s -H "Authorization: token $GH_TOKEN" "https://api.github.com/repos/$owner/$repo/commits/$commit_sha/pulls" | jq -r '.[] | .number')
      # echo "Pull request numbers: $pull_request_numbers"
      if [[ -n "$pull_request_numbers" ]]; then
        for pull_request_number in $pull_request_numbers; do
          # Use the pull request number to fetch review details
          reviewers=$(curl -s -H "Authorization: token $GH_TOKEN" "https://api.github.com/repos/$owner/$repo/pulls/$pull_request_number/reviews" | jq -r '.[] | {user: .user.login, state: .state, submitted_at: .submitted_at}')
          # echo "Reviewers: $reviewers"
          if [[ -n "$reviewers" && "$reviewers" != "[]" ]]; then
            # Update the commit_json with pull_request_details
            commit_json=$(echo "$commit_json" | jq --argjson reviewers "$reviewers" '. + {pull_request_details: $reviewers}')
          fi
        done
      fi

      # Write the commit_json to tmp_updated.json regardless of having pull request details or not
      echo "$commit_json" >> tmp_updated.json
    done

    # Replace the old output file with the new updated temporary file
    # Ensure it's a valid JSON array
    jq -s '.' tmp_updated.json > "$output_file"
    rm tmp_updated.json

    cat $output_file
}

# all_commits $1 $2 $3 $4
