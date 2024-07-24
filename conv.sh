#!/bin/bash


git log --pretty=format:'{"commit":"%H","abbreviated_commit":"%h","tree":"%T","abbreviated_tree":"%t","parent":"%P","abbreviated_parent":"%p","refs":"%D","encoding":"%e","subject":"%s","sanitized_subject_line":"%f","body":"%b","commit_notes":"%N","verification_flag":"%G?","signer":"%GS","signer_key":"%GK","author":{"name":"%aN","email":"%aE","date":"%aD"},"commiter":{"name":"%cN","email":"%cE","date":"%cD"}}' v14..HEAD > tmp
# Define the input and output file paths
output_file="output.json" # The file where the output will be saved

# Start the JSON array
echo "[" > "$output_file"

# Read the file line by line
total_lines=$(cat tmp | wc -l) # Get the total number of lines
echo $total_lines
current_line=0
while IFS= read -r line || [ -n "$line" ]; do
  current_line=$((current_line + 1))
  # For every line except the last, add a comma at the end
  if [ "$current_line" -le "$total_lines" ]; then
    echo "  $line," >> "$output_file"
  else
    echo "  $line" >> "$output_file"
  fi
done < tmp

# End the JSON array
echo "]" >> "$output_file"
cat $output_file
