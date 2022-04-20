# 42sp_pipex
pipex made with ❤ for 42sp.

# File Descriptors

- In UNIX systems, `EVERYTHING IS A FILE` and a `file descriptor` is a unique identifier for a file or other input/output resources (like sockets, pipes, etc).
- When the user opens a file, a socket or another resource, the kernel assigns a non-negative integer to identify it within a indexed sequential table, which maps to file descriptors currently in use.
- That way, when we open an existing file or create a new file, the kernel will return a file descriptor to the associated process. In the same manner, when the resource is closed, the file descriptor is freed and becomes available for another process to use it.
- By convention, the file descriptors are assigned as follows:

	|  File  | File Descriptor |
	|:------:|:---------------:|
	|  STDIN |        0        |
	| STDOUT |        1        |
	| STDERR |        2        |

- We can check the FD for a process in `/proc/$pid/fd`.

# Redirection

## Output Redirection

### Overwriting/creating files with `>`

- The `>` symbol is used for output (STDOUT) redirection. In other words, it redirects the output of the command right before it to the source right after it.
- It is possible to redirect the STDOUT to files, devices and many other sources.
- While using files, if the file does not exist, it will be created. If the file exists, it will be overwritten.

	```
	# Redirects the ps aux command to the comm_out file. If the
	# file does not exist, it will be created.
	$ ps aux > comm_out
	```

### Appending to/creating files with `>>`

- The `>>` symbol is also used for output (STDOUT) redirection, but it has a major difference: if the provided file already exists, it appends the output to the end of the file.
- While using `>>` if the file does not exists, it will be created in the same manner as the `>` command does.

## Input Redirection

### Redirecting Input with `<`

- The `<` symbol is used for input (STDIN) redirection. The shell interprets as "read it from the provided source instead of reading from the keyboard".
- The input redirection is commonly used to read from a file and pass it as a command input, like the following:

	```
		# Redirects the output of the `ls` command to a file called dirlist
		$ ls > dirlist
		# Used the dirlist file as a input for the `wc` command
		$ wc -l < dirlist
	```

### Here Documents `<<`

- The `<<` combination is used to tell shell to read the input from the provided source until a line containing the marker that follows it, without trailing blanks (which required to be trimmed if needed). All the lines are read until the marker is found and then fed to the command.
- The `marker` cannot be a variable expansion, a command substitution, filename or a arithmetic expansion. If any part of `word` is quoted, the delimiter is the result of the quote removal; if it is not quoted, all lines in the provided document are subjected to parameter expansion.

## Selecting file descriptors with `&`

- The `&` in the context of redirections defines a file descriptor, moreover, it tells bash to redirect a stream to a file descriptor which is a integer.
- To redirect STDOUT to STDERR we can do any of the following:

	```
	$ >&word
	$ &>word
	# All above ways work
	$ >word 2>&1
	$ echo "test" 1>&2
	```

- To append STDOUT to STDERR we can do:
	```
	$ &>>word
	## Is also semantically equivalent to
	$ >>word 2>&1
	```

# Useful functions

## `int pipe(int fds[2])`
- @params - int fds[2]
	- fd[0] - file descriptor for the ***read*** end of pipe (STDIN).
	- fd[1] - file descriptor for the ***write*** end of pipe (STDOUT).
- @returns
	- 0 on success.
	- -1 on error.
- A pipe is conceptually a connection established between two processes, in such a way that the STDIN for one process becomes the STDOUT of the other process. The pipe system, then calls the first two available FDs in the FD table and allocates them for read and write ends of the created pipe.
- The pipes use the FIFO in a queue data structure. The sizes of read and write might not match.

## `void exit(int __status)`
- @params
	- __status - The status code value returned to the parent associated process.
- @returns
	- void

- Terminates the process in which it is called upn and closes all file descriptors that belong to it. Usually, the `__status` codes are `EXIT_FAILURE = 1` and `EXIT_SUCCESS = 0` declared in`<stdio.h>`.
- The `return()` function in the main function is equivalent to `exit()`.

## `pid_t fork(void)`
- @params
	- void
- @returns
	- Success: The PID of the child process in the parent and 0 on the child.
	- Failure: -1 is returned in the parent and no child process is created, indicated by `errno`.

- The `fork()` function duplicates the calling process, duplicating it. The first process is called ***parent*** and the newly duplicated is called ***child***.


## `int close(int fd)`
- @params:
	- fd - the file descriptor to be closed.
- @returns:
	- Success: 0.
	- Error: -1. `errno` is set with the error.

- Pretty straightforward: closes the provided file descriptor making it reusable. Any record locks associated with the opened file and removed. It it refers to the last opened file description with `open()` the alocated resources are freed; if the file has been removed using `unlink()`, the file is deleted.

## `int dup(int oldfd)`
-@params:
	- oldfd - the refered file descriptor.
- @returns
	- Success: the new fd.
	- Error: -1. `errno` is set with the error.

- The `dup()` function allocates a new file descriptor that refers to the same file descriptor passed in `oldfd`. The newly created file descriptor is guaranteed to be the ***lowest-numbered*** file descriptor unused at the moment of the calling. They do not share the same flags, as `dup3()` is used for that purpose.
- The closing and reusage tasks are performed ***atomically**, meaning that it happens one at a time. In multithreaded processes, the use of `dup()` and `close()` is dangerous. When a file descriptor is in use by system calls or threads in the same process, when a parallel thread allocates a file descritpr or incase of interruption of the program by a signal handler that allocates a file descriptor, the use of these functions together might result in race conditions, namely when `newfd` might be reused between the calling of `dup()` and `close()`.

## `int dup2(int oldfd, int newfd)`
- @params:
	- oldfd  - file descriptor to be refered to.
	- newfd - new file descriptor that refers to the parent file descriptor.
- @returns
	- Success: the new fd that must be a valid file descriptor.
	- Error: -1. `errno` is set with the error.

- Works exactly like the `dup()` function, except it uses the file descriptor specified in `newfd` instead of the lowest-numbered in the file descriptor table. If the `newfd` was previously open, it is closed silently before getting reused.
- In cases where used with `close()` the `dup2()` function will not indicate or return errors associated with `close()`, hence why it is wise to check for the return value of `close()` beforehand.

## `int access(const char *pathname, int mode)`
- @params:
	- pathname - the path of file to be checked
	- mode - the access mode to be tested, namely the bitwise-inclusive `|` or `OR` to test several at once or `F_OK` `R_OK` `W_OK` `X_OK` to test if file exists, read access, write access and execution access, respectively.
- @return
	- Sucess: 0 meaning that the tested access is permited.
	- Failure: -1 meaning that the file cannot be accessed, setting `errno` to the appropriate value.

- Checks if a process has the permissions to access a file provided in `pathname` by looking at the real user ID (UID) and group ID (GID). If the `pathname` is a symlink, it is dereferenced to the actual target file.

## `int execve(const char *pathname, char *const argv[], char *const envp[])`
- @params
	- pathname - the program to execute, refered to by its pathname pointer. It must be a binary executable or a script starting with `!#interpreter [args]`
	- argv - an array of argument strings passed to the program pointed by pathname, terminated by a NULL pointer, meaning that `argv[argc] == NULL`. By convention, the first of them `argv[0]` must contain the filename associated with the file being executed.
	- envp - is an array of pointer to strings in the form `key=value` as environment variables that follow the env variables conventions(case sensitiveness, must not contain the equal sign `=`,system-defined variables are all uppercase, their value can be represented as a string and must not contain an embedded null character).
- @returns
	- Success: Does not return, since it replaces the current process with the new one and the old one does not exists anymore. If the new process succeeds, it replaces the calling process, if it fails, it has nothing to do with `execve()` and returns back so the programmer can deal with the error.
	- Error: -1 is returned with the appropriate `errno`.

- The `execve()` function executes the program pointed to by `pathname` If it succeeds, all the data and stack of the calling process are overwritten by the new one.

## `int open(const char *pathname, int flags)`
- @params
	- pathname - the path of the file to be opened.
	- flags - The flags describing the operations to be carried on within the file. There are several variations on the mode.
- @returns
	- Success: Returns the integer relative to the newly created file descriptor.
	- Error: -1 is returned and `errno` is set to indicate the error.

## `char *strerror(int errnum)`
- @params
	- errnum - the error number relative to be returned.
- @returns
	- A pointer to the string that contains the name of the error code provided as argument.

## `void perror(const char *str)`
- @params
	- str - the descriptive custom error message to be printed at stderr before the error message itself.
- @returns
	- void

## `ssize_t write(int fd, const void *buf, size_t count)`
- @params
	- fd - the file descriptor relative to the file to be written in.
	- buf - the memory buffer on which the bytes will be written in and to the file pointed by the respective fd.
	- count - the amount to be written in bytes.
- @returns
	- Success: the amount of bytes written.
	- Error: -1 and `errno` is setup to indicate the error.

## `pid_t wait(int *wstatus)`
- @params
	- wstatus - describes the reason which caused the termination of the child process. It can also be `NULL` for when the status is not stored.
- @returns
	- Success: the PID of the terminated child process.
	- Error: -1 and sets `errno`.

- The `wait()` system call blocks the calling process until one of its child processes exits or receives a signal. There are two possible situations: 1) if there are at least one process running when `wait()` is called, the caller will be blocked until one of its child processes exits. The called then resumes its execution. 2) If there is no child processes running, then calling `wait()` has no effect at all.

## `pid_t waitpid(pid_t pid, int *wstatus, int options)`
- @params
	- pid - the specified PID to be watched for state changes.
	- stat_loc - if not `NULL`, it stores the status message in the int to which it points.
	- options - The options value, which may vary. Specifies the behaviour.
- @returns
	- Success: the PID of the child whose state has changed.
	- Error: -1 and sets `errno`.

## `int unlink(const char *pathname)`
- @params
	- pathname - the pathname of the name to be deleted from the filesystem.
- @returns
	- Success: returns 0.
	- Error: returns -1 and sets up `errno`.

- The `unlink()` function deletes the file that refers to the provided pathname. The disk space used by the deleted file is then made available for reuse.


## Sources:

- [GNU.org - Redirections (Bash Reference Manual)](https://www.gnu.org/software/bash/manual/html_node/Redirections.html)

- [IBM Developer - Prepare for LPIC-1 exam 1 – topic 103.4: Streams, pipes, and redirects](https://developer.ibm.com/tutorials/l-lpic1-103-4/)

- [die.net](https://linux.die.net/)

- [The GNU Manuals Online](https://www.gnu.org/manual/manual.en.html)

- [man7.org](https://man7.org)

- [The Open Group Base Specifications](https://pubs.opengroup.org/)