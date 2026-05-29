
### Common Regex Patterns:
```bash
\d - Matches any digit.
\D - Matches any non-digit character.
\s - Matches any whitespace.
\W - Matches any non-word character (like punctuation).

Example: To find a phone number pattern like 123-456-7890, you can use:

\d{3}-\d{3}-\d{4}
```
# 3. Iteration Control Using Break and Continue
 - In shell scripting, break and continue are essential for controlling loops.

`Break:` Used to exit a loop when a condition is met.
`Continue:` Used to skip the current iteration of the loop and move on to the next iteration.

```bash

Example:

for i in {1..10}; do
  if [[ $i -eq 5 ]]; then
    break  # Stops the loop when i equals 5
  fi
  echo $i
done
```
