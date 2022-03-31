# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jakira-p <jakira-p@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2022/03/31 04:03:46 by jakira-p          #+#    #+#              #
#    Updated: 2022/03/31 04:31:47 by jakira-p         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME = pipex

CC = clang

CFLAGS = -Wall -Wextra -Werror

SRC_DIR = src/

UTILS_DIR = utils/

DIST_DIR = dist/

SRC_FILES = $(SRC_DIR)main.c \

OBJS = $(addprefix $(DIST_DIR),$(notdir $(SRC_FILES:.c=.o)))

INCLUDES = -I ./includes -I ./libft

LIBS = -L ./libft -lft

all: $(NAME)

$(NAME): $(OBJS) libft
	$(CC) $(CFLAGS) $(OBJS) $(INCLUDES) $(LIBS) -o $@

$(DIST_DIR)%.o: $(SRC_DIR)%.c
	@mkdir -p $(DIST_DIR)
	$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $(DIST_DIR)$(notdir $@)

$(DIST_DIR)%.o: $(UTILS_DIR)%.c
	@mkdir -p $(DIST_DIR)
	$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $(DIST_DIR)$(notdir $@)

clean:
	@echo "[ ] Cleaning up pipex object files and directories..."
	rm -rf $(DIST_DIR)
	@echo "[X] pipex object files cleaned successfully"
	@echo "[ ] Cleaning up libft..."
	@$(MAKE) -s -C ./libft clean
	@echo "[X] libft cleaned successfully"

fclean: clean
	@echo "[ ] Cleaning up pipex executable ..."
	rm -rf $(NAME)
	@echo "[X] pipex executable cleaned successfully"
	@echo "[ ] Cleaning up libft..."
	@$(MAKE) -s -C ./libft fclean
	@echo "[X] libft cleaned successfully"

re: fclean all

libft:
	@echo "[ ] Compiling libft..."
	@$(MAKE) -s -C ./libft
	@echo "[X] libft compiled successfully"

.PHONY: all clean fclean re libft