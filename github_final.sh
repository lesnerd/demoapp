#!/bin/bash

function all_commits() {
    local owner="$1"
    local repo="$2"
    local GH_TOKEN="$3"
    # Get the commit details in JSON format for all commits since the last tag
    git log --pretty=format:'{"commit":"%H","abbreviated_commit":"%h","tree":"%T","abbreviated_tree":"%t","parent":"%P","abbreviated_parent":"%p","refs":"%D","encoding":"%e","subject":"%s","sanitized_subject_line":"%f","body":"%b","commit_notes":"%N","verification_flag":"%G?","signer":"%GS","signer_key":"%GK","author":{"name":"%aN","email":"%aE","date":"%aD"},"commiter":{"name":"%cN","email":"%cE","date":"%cD"}}' v14..v15 > tmp
    output_file="output.json" # The file where the output will be saved
    echo "[" > "$output_file"
    total_lines=$(cat tmp | wc -l) # Get the total number of lines
    current_line=0
    while IFS= read -r line || [ -n "$line" ]; do
      current_line=$((current_line + 1))
      if [ "$current_line" -le "$total_lines" ]; then
        echo "  $line," >> "$output_file"
      else
        echo "  $line" >> "$output_file"
      fi
    done < tmp
    echo "]" >> "$output_file"
    rm tmp

    > tmp_updated.json

    # Iterate over each commit in output_file
    jq -c '.[]' "$output_file" | while read -r commit_json; do
      commit_sha=$(echo "$commit_json" | jq -r '.commit')
      pull_request_numbers=$(curl -s -H "Authorization: token $GH_TOKEN" "https://api.github.com/repos/$owner/$repo/commits/$commit_sha/pulls" | jq -r '.[] | .number')

      if [[ -n "$pull_request_numbers" ]]; then
        for pull_request_number in $pull_request_numbers; do
          # Use the pull request number to fetch review details
          reviewers=$(curl -s -H "Authorization: token $GH_TOKEN" "https://api.github.com/repos/$owner/$repo/pulls/$pull_request_number/reviews" | jq -r '.[] | {user: .user.login, state: .state, submitted_at: .submitted_at}')
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

owner="lesnerd"
repo="demoapp"
TOKEN="<some_token>"

all_commits "$owner" "$repo" "$TOKEN"
