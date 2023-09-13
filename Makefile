NAME			= libasm.a
TESTER_NAME		= tester

AR			= ar
AR_FLAGS		= rcs

NASM			= nasm
NASM_FLAGS		= -f elf64

LD			= ld
LD_FLAGS		= -L. -lasm -lc -dynamic-linker /lib64/ld-linux-x86-64.so.2

BONUS_DIR		= .

SRC_DIR			= $(BONUS_DIR)/src
SRC_EXT			= s
SRC_FILES		= $(wildcard $(SRC_DIR)/*.$(SRC_EXT))

OBJ_DIR			= $(BONUS_DIR)/obj
OBJ_FILES		= $(patsubst $(SRC_DIR)/%.$(SRC_EXT), $(OBJ_DIR)/%.o, $(SRC_FILES))

TEST_SRC_DIR		= $(BONUS_DIR)/test
TEST_SRC_EXT		= s
TEST_SRC_FILES		= $(wildcard $(TEST_SRC_DIR)/*.$(TEST_SRC_EXT))

all			: $(NAME)

$(NAME)			: $(OBJ_DIR) $(OBJ_FILES) $(TEST_SRC_FILES)
			$(AR) $(AR_FLAGS) $@ $(OBJ_FILES)
			$(MAKE) $(TESTER_NAME)

$(OBJ_DIR)		:
			@mkdir $(OBJ_DIR)

$(OBJ_DIR)/%.o		: $(SRC_DIR)/%.$(SRC_EXT)
			$(NASM) $(NASM_FLAGS) $< -o $@

$(TESTER_NAME)		: $(OBJ_DIR) $(OBJ_FILES) $(TEST_SRC_FILES)
			$(NASM) $(NASM_FLAGS) $(TEST_SRC_DIR)/main.s -o $(TESTER_NAME).o
			$(LD) $(TESTER_NAME).o -o $(TESTER_NAME) $(LD_FLAGS)
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
			$(MAKE) BONUS_DIR=bonus
			$(MAKE) BONUS_DIR=bonus tester

.PHONY			: all clean fclean re bonus bonus_tester