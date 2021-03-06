/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   main.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: jakira-p <jakira-p@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2022/03/31 04:24:31 by jakira-p          #+#    #+#             */
/*   Updated: 2022/04/15 04:36:34 by jakira-p         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <pipex.h>

// Handle first the exceptions
int main(int argc, char **argv, char **envp)
{
	t_pipex *pipex;

	if (argc != 5)
		exit_error("Error: Wrong number of arguments provided.\n");
	pipex = new_pipex();
	if (pipe(pipex->fds) == -1)
		exit_error("Error: FD error.\n");
		// continues
}