NAME		= libasm.a

AR		= ar
AR_FLAGS	= rcs

NASM		= nasm
NASM_FLAGS	= -f elf64

LD		= ld
LD_FLAGS	= -L. -lasm -lc -dynamic-linker /lib64/ld-linux-x86-64.so.2

SRC_DIR		= src
SRC_EXT		= s
SRC_FILES	= $(wildcard $(SRC_DIR)/*.$(SRC_EXT))
SRC_COUNT	= $(shell find $(SRC_DIR) -type f -name "*.$(SRC_EXT)" | wc -l)

OBJ_DIR		= obj
OBJ_FILES	= $(patsubst $(SRC_DIR)/%.$(SRC_EXT), $(OBJ_DIR)/%.o, $(SRC_FILES))

all		: $(NAME)

ifeq ($(SRC_COUNT), 6)
$(NAME)		: $(OBJ_DIR) $(OBJ_FILES)
		$(AR) $(AR_FLAGS) $@ $(OBJ_FILES)
else
$(NAME)		:
		@echo "Srcs corrupted, aborting"
endif

$(OBJ_DIR)	:
		@mkdir $(OBJ_DIR)

$(OBJ_DIR)/%.o	: $(SRC_DIR)/%.$(SRC_EXT)
		@$(NASM) $(NASM_FLAGS) $< -o $@

test		:
		$(NASM) $(NASM_FLAGS) test/main.s -o tester.o
		$(LD) tester.o -o tester $(LD_FLAGS)

clean		:
		rm -rf $(OBJ_DIR) tester.o

fclean		: clean
		rm -f $(NAME) tester

re		: fclean all

.PHONY		: all clean fclean re test