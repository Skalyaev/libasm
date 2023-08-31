NAME				=	libasm.a

NASM				=	nasm
NASM_FLAGS			=	-f elf64
AR					=	ar
AR_FLAGS			=	rcs
LD					=	ld
LD_FLAGS			=	-L. -lasm -lc -dynamic-linker /lib64/ld-linux-x86-64.so.2

SRC_DIR				=	src
SRC_EXT				=	s
SRC_FILES			=	$(wildcard $(SRC_DIR)/*.$(SRC_EXT))
SRC_COUNT			=	$(shell find $(SRC_DIR) -type f -name "*.$(SRC_EXT)" | wc -l)

OBJ_DIR				=	obj
OBJ_FILES			=	$(patsubst $(SRC_DIR)/%.$(SRC_EXT), $(OBJ_DIR)/%.o, $(SRC_FILES))

INDEX				=	0
BUILD_SIZE			=	$(SRC_COUNT)

_STOP				=	\e[0m
_GREEN				=	\e[92m
CLEAR				=	'	                                                     \r'
FULL				=	-->[$(_GREEN)===================================$(_STOP)]<--[ $(_GREEN)100%$(_STOP) ]

define update_bar	=
	BAR				=	-->[$(_GREEN)$(shell printf "%0.s=" $$(seq 0 $(shell echo "$(INDEX) * 33 / $(BUILD_SIZE)" | bc)))$(shell printf "%0.s " $$(seq $(shell echo "$(INDEX) * 33 / $(BUILD_SIZE)" | bc) 33))$(_STOP)]<--[ $(_GREEN)$(shell echo "$(shell echo "$(INDEX) * 33 / $(BUILD_SIZE)" | bc) * 3" | bc)%$(_STOP) ]
endef

#--------------------------------------------------------->>

all					:	$(NAME)

ifeq ($(SRC_COUNT), 6)
$(NAME)				:	$(OBJ_DIR) $(OBJ_FILES)
						@$(AR) $(AR_FLAGS) $@ $(OBJ_FILES)
						@echo -ne $(CLEAR)
						@echo -e '	$(NAME) $(_GREEN)created$(_STOP).'
						@echo -e '	$(FULL)'
else
$(NAME)				:
						@echo "Srcs corrupted, aborting"
endif

$(OBJ_DIR)			:
						@mkdir $(OBJ_DIR)

$(OBJ_DIR)/%.o		:	$(SRC_DIR)/%.$(SRC_EXT)
						@$(NASM) $(NASM_FLAGS) $< -o $@
						@$(eval INDEX=$(shell echo $$(($(INDEX)+1))))
						@$(eval $(call update_bar))
						@echo -ne $(CLEAR)
						@echo -e '	$@ $(_GREEN)created$(_STOP).'
						@echo -ne '	$(BAR)\r'

test				:
						@$(NASM) $(NASM_FLAGS) test/main.s -o main.o
						@$(LD) main.o $(LD_FLAGS) -o tester

clean				:
						@rm -rf $(OBJ_DIR) main.o
						@echo -ne $(CLEAR)
						@echo -e '	obj directory $(_GREEN)removed$(_STOP).'

fclean				:	clean
						@rm -f $(NAME) tester
						@echo -ne $(CLEAR)
						@echo -e '	$(NAME) $(_GREEN)removed$(_STOP).'

re					:	fclean all

.PHONY				:	all test clean fclean re debug