NAME			= libasm.a
TESTER_NAME		= tester

AR			= ar rcs
NASM			= nasm -f elf64
LD			= ld
LD_LIBS			= -L. -lasm -lc -dynamic-linker /lib64/ld-linux-x86-64.so.2

WORKING_DIR		= .

SRC_DIR			= $(WORKING_DIR)/src
SRC_EXT			= s
SRC_FILES		= $(wildcard $(SRC_DIR)/*.$(SRC_EXT))

OBJ_DIR			= $(WORKING_DIR)/obj
OBJ_FILES		= $(patsubst $(SRC_DIR)/%.$(SRC_EXT), $(OBJ_DIR)/%.o, $(SRC_FILES))

TEST_SRC_DIR		= $(WORKING_DIR)/test
TEST_SRC_EXT		= s
TEST_SRC_FILES		= $(wildcard $(TEST_SRC_DIR)/*.$(TEST_SRC_EXT))

all			: $(NAME)

$(NAME)			: $(OBJ_DIR) $(OBJ_FILES) $(TEST_SRC_FILES)
			$(AR) $@ $(OBJ_FILES)
			$(MAKE) $(TESTER_NAME)

$(OBJ_DIR)		:
			@mkdir $(OBJ_DIR)

$(OBJ_DIR)/%.o		: $(SRC_DIR)/%.$(SRC_EXT)
			$(NASM) $< -o $@

$(TESTER_NAME)		: $(OBJ_DIR) $(OBJ_FILES) $(TEST_SRC_FILES)
			$(NASM) $(TEST_SRC_DIR)/main.s -o $(TESTER_NAME).o
			$(LD) $(TESTER_NAME).o -o $(TESTER_NAME) $(LD_LIBS)
			@rm $(TESTER_NAME).o
			@echo
			@echo "Done, you can now launch ./$(TESTER_NAME)"
			@echo

clean			:
			rm -rf $(OBJ_DIR) bonus/$(OBJ_DIR)

fclean			: clean
			rm -f $(NAME) $(TESTER_NAME)

re			: fclean all

bonus			:
			$(MAKE) WORKING_DIR=bonus
			$(MAKE) WORKING_DIR=bonus tester

.PHONY			: all clean fclean re bonus bonus_tester