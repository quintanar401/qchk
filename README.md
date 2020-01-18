# Q Access Control System

qchk ensures that user queries either in string or binary format can't modify any internal or external state if this is not authorized explicitly. That is:
* A query can't read or write to any variable or system path without explicit authorization.
* A query can't read or write to any variable using its symbolic name or indirectly using another variable or some expression.
* A query also can't do this using QSQL statements or side effects of system functions.
* Certain functions like hopen are not allowed. It is expected that if this functionality is needed it is provided via a custom API.
* Some functions (like value) are restricted to a subset of their functionality.

All these restrictions are to ensure that a user can't modify or read or open any variable or file or handle without permission. If all user queries are checked and he doesn't have access to functions similar to value, eval and etc you are 100% guaranteed that he will not be able to read/modify anything.

A user still can use functions, save them in his own namespace (if this is allowed), execute them, execute QSQL statements. All functions will be saved in their checked form and will be safe to use.

To perform checks:
* pass the input expression to .qchk.checkv (it expects a string or a value expression) or .qchk.check (expects a string or a parse expression). It will either throw an access exception or return an eval ready expression.
* evaluate the result of the check function using eval. There may be an access exception.

Reimplement functions:
* .qchk.chkH - for allowed handles.
* .qchk.chkR - check read access to a name.
* .qchk.chkW - check write access to a name.
* .qchk.err - action on an access error. Note that you are not required to throw an exception, you can just record the access violation.

## Restricted functions

### Blocked functions

These functions will cause the access exception: hopen hclose hcount read0 read1 exit 0: 1: 2: 2:: save load rsave rload setenv dsave.

### Restricted functions

* key - requires read access for x.
* value/get - read access if x is a symbol, value of enum/dict/table, eval on (fn;arg1;..) with full check for fn (eval + check if it is a string), eval + check for strings, an exception otherwise.
* parse - apply checks recursively for the result of parse.
* eval/reval - apply checks recursively to x.
* set - write access for x.
* insert/upsert - write access for x.
* each/peach/scan/over/prior - handle and read access for x.
* @[x;y] - handle and read access for x.
* .[x;y] - read access for x.
* @ or .[x;y;z] - read access for x. If type[x]<100 then handle and read access for z.
* @ or .[x;y;z;a] - read access for x. If type[x]<100 then handle and read access for z.
* ! - read access for x, write access for y, if x is a number then exception if it is less than 0 or null (deny -3!x).
* ? - write access for x, read access for y unless it is in \`0..\`9.
* ?[x;y;z] - no checks if x is a boolean vector, otherwise apply checks to z with columns of x.
* tables - for the global namespace filter the result according to the read access rights, otherwise check x for read access.
* views - filter the result according to the read access rights.
* view/cols/keys/fkeys/meta - read access for x.
* xkey/xasc/xdesc - write access for x.
* not - it is the same function as hdel thus it will fail if x is a symbol.
* pj - read access for y.
* wj/wj1 - check recursively the last arg using its table columns.
* system - allow "a", "t", "ts" and "f" args and filter/process them according to the access rights.
* any function call - check the function for read and handle access.
* any adverb creation - check the function for read and handle access.
* function composition - check both args for read and handle access.
* QSQL - apply checks to args using table columns and local variables.
* parted functions - apply checks as though it is a normal function call.
* assignments - write access, some assignments like .: are not allowed.
