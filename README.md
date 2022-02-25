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

### Overwriting files with `>`

- The `>` symbol is used for output (STDOUT) redirection. In other words, it redirects the output of the command right before it to the source right after it.
- It is possible to redirect the STDOUT to files, devices and many other sources.
- While using files, if the file does not exist, it will be created. If the file exists, it will be overwritten.

	```
	# Redirects the ps aux command to the comm_out file. If the
	# file does not exist, it will be created.
	$ ps aux > comm_out
	```

### Appending to files with `>>`

- The `>>` symbol is also used for output (STDOUT) redirection, but it has a major difference: if the provided file already exists, it appends the output to the end of the file.
- While using `>>` if the file does not exists, it will be created in the same manner as the `>` command does.

## Input Redirection

- (ongoing)