***Key Concepts**
- Standard Streams:
- **stdin: Standard Input** (File descriptor 0)
- **stdout: Standard Output** (File descriptor 1)
- **stderr: Standard Error** (File descriptor 2)

# Output Redirection:

- > : Redirects the output and overwrites the content in the file.

- >> : Redirects the output and appends it to the file.

- Tee Command: Redirects the output to a file and displays it on the screen simultaneously.

#How to Execute:
- 1.Save the script as std-script.sh.
- 2.Run it using bash std-script.sh.

#Requirements:
- Print only successful commands:
   ``` bash std-script.sh 2> /dev/null ```
   - Redirects any errors (stderr) to /dev/null, so only the output of successful commands is shown.

- Print only failed commands:

  ``` bash std-script.sh 1> /dev/null ```
  - Redirects standard output (stdout) to /dev/null, so only error messages (stderr) are displayed.

#Overwriting and Appending Output:
- To redirect both stdout and stderr to a file:

  ```bash std-script.sh > /tmp/error 2>&1``
     -  This will overwrite the file with both standard output and errors.

- To append instead of overwriting:

  ```bash std-script.sh >> /tmp/error 2>&1```

#Display and Save Output:
- To display output on the screen and save it to a file:

  ```bash std-script.sh | tee /tmp/tee1``
- If you want to append to the file instead of overwriting:
  ```bash std-script.sh 2>&1 | tee -a /tmp/tee1``