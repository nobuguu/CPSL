
#ifndef __PREPROCESS_H
#define __PREPROCESS_H

#include "parse_tree.h"

void process_symbols(Program*);
void process_c_decl(ConstDecl*);
void process_t_decl(TypeDecl*);
void process_v_decl(VarDecl*);
void process_s_decl(SubroutineDecl*);

#endif
