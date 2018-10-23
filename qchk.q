.qchk.pf:{if["["=first x:-1_1_ string x; x:(1+first where"]"=x)_x]; x[where x in"\r\n"]:" "; parse x}; / parse fn
/ .qchk.ps:{x:x where not 2=0 (0 0 1 1 0 3 0 0;0 0 1 1 2 3 0 0;0 0 2 2 2 2 2 2;3 3 3 3 3 0 4 3;3 3 3 3 3 3 3 3)\"\r\n\t /\"\\"?x; x[where x in"\r\n"]:" "; parse x}; / parse str, remove comments
.qchk.ps:parse;
.qchk.pv:{$[type[x]in 0 11h; x[0],.qchk.ve each 1_ x;.qchk.ve x]}; / parse value expr (unwind complex types)
.qchk.ve:{$[11=abs t:type x;$[0=count x;($;(),`;());(1=count x)&11=t;(enlist;x);enlist x];0>t;$[-19>t;($;(),key x;value x);x];0=t;$[0=count x;x;enlist[enlist],.z.s each x];98>t;$[0=count x;($;(),key x;());1=count x;(enlist;.z.s x 0);
  20>t;x;($;(),key x;value x)];98=t;(flip;.z.s flip x);99=t;(!;.z.s key x;.z.s value x);t<104;x;(not null .q?x)|x in(<>;<=;>=);x;t=112;x;t>112;'"unexp";[v:.z.s each value x;$[104=t;v;enlist[(';';/;\;':;/:;\:)t-105],v]]]};

/ raze accepts only pure unbreakable exprs (with exception of .q primitives). Apply .qchk.ve first to all composite values including `$(), enlist 1 and etc.
.qchk.razeFn:{[a;e] value"{[",(";"sv string a),"]",$[(";"~first e)&0=type e;";\n  "sv .qchk.razeExp each 1_e;.qchk.razeExp e],"}"};
.qchk.razeExp:{$[(t>99)|0>t:type x;.qchk.razeA x;t in 0 11h;.qchk.raze0 x;20>t;.qchk.razeL x;'"unexpected expr: ",.Q.s1 x]};
.qchk.razeA:{$[type[x]within 100 111h;$[104=type(1;x);"";null n:.q?x;$[100<type x;"(",string[x],")";string x];string n];(t:.Q.t abs type x)in" g";'"unsupported atom: ",.Q.s1 x;t="s";string x;$[x<0;" ";()],.Q.s1 x]};
.qchk.raze0:{if[0=c:count x;:"()"]; x0:x 0; if[1=c;:$[11=type x0;$[1=count x0;"enlist ",;::]raze"`",/:string x0;-11=type x0;"`",string x0;"enlist ",.qchk.razeExp x0]]; v:.qchk.razeExp each x; v1:";"sv 1_v;
  if[-10=t:type x0; :$[x0=";";"[",v1,"]";x0 in "':";"(",x0,v1,")";v[0],"[",v1,"]"]]; $[(2=c)&103=t;"((",v[1],")",v[0],")";x0~(enlist);$[2=c;v[0]," ",v1;"(",v1,")"];(c=3)&$[101=type x0;20>value x0;x0~(:)];v[1],string[x0]," ",v 2;v[0],"[",v1,"]"]};
.qchk.razeL:{t:.Q.t type x; $[t in " gef";"(",(";"sv .qchk.razeA each x),")";t="c";"\"",raze[.qchk.CMap x],"\"";t="s";raze"`",/:string x;t="x";"0x",raze string x;t="b";(raze string x),t;(raze" ",/:@[string x;where null x;{[x;y]x}.Q.s1 x -1]),t]};
.qchk.CMap:(-1_1_)each .Q.s1 each "c"$til 256;

/ q proxies, q namespace to avoid 'globals
{.q[`$string x]:x}(2::;0:;1:;2:;exit;setenv;insert); / name them for access denied
.q[`find`at2`dot2]:(?;@;.);
.q.ch_key:.q.ch_inv:{key .qchk.chkR x};
.q.ch_value:.q.ch_get:{if[not(t=-11)|(t:type x:.qchk.chkR x)within 20 99h;.qchk.err"value accepts only enums, symbols, tables and dicts"]; value x};
.q.ch_parse:{.qchk.chkExpr[parse x;()]};
.q.ch_eval:{eval .qchk.chkExpr[x;()]};
.q.ch_reval:{reval .qchk.chkExpr[x;()]};
.q.ch_set:{.qchk.chkW[x] set y};
.q.ch_insert:{.qchk.chkW[x]insert y};
.q.ch_upsert:{.qchk.chkW[x]upsert y};
.q.ch_each:{.qchk.chkH[.qchk.chkR x]each y};
.q.ch_peach:{.qchk.chkH[.qchk.chkR x]peach y};
.q.ch_scan:{.qchk.chkH[.qchk.chkR x]scan y};
.q.ch_over:{.qchk.chkH[.qchk.chkR x]over y};
.q.ch_prior:{.qchk.chkH[.qchk.chkR x]prior y};
.q.ch_at2:{.qchk.chkH[.qchk.chkR x] y};
.q.ch_dot2:{.qchk.chkR[x]. y};
.q.ch_at3:{@[x;y;$[100>type x:.qchk.chkW x;.qchk.chkH .qchk.chkR z;z]]};
.q.ch_dot3:{.[x;y;$[100>type x:.qchk.chkW x;.qchk.chkH .qchk.chkR z;z]]};
.q.ch_at4:{[x;y;z;a]@[x;y;$[100>type x:.qchk.chkW x;.qchk.chkH .qchk.chkR z;z];a]};
.q.ch_dot4:{[x;y;z;a].[x;y;$[100>type x:.qchk.chkW x;.qchk.chkH .qchk.chkR z;z];a]};
.q.ch_lsq:{if[(type x)in -6 -7h;if[(x<0)|null x;.qchk.err"access to internal functions like -n!exp is denied"]]; ![.qchk.chkR x;.qchk.chkW y]}; / !
.q.ch_find:{?[.qchk.chkW x;$[-11=type y;$[y in`0`1`2`3`4`5`6`7`8;y;.qchk.chkR y];y]]}; / ?
.q.ch_exec:{if[1=type x;:?[x;y;z]]; ?[x;y;.qchk.chkExpr[z;cols x]]};
.q.ch_tables:{$[any x~/:(::;`;`.);.qchk.chkRFlt tables[];-11=type x;tables .qchk.chkR x;'"type"]};
.q.ch_views:{.qchk.chkRFlt views[]};
.q.ch_view:{view .qchk.chkR x};
.q.ch_cols:{cols .qchk.chkR x};
.q.ch_keys:{keys .qchk.chkR x};
.q.ch_fkeys:{fkeys .qchk.chkR x};
.q.ch_meta:{meta .qchk.chkR x};
.q.ch_xkey:{x xkey .qchk.chkW y};
.q.ch_xasc:{x xasc .qchk.chkW y};
.q.ch_xdesc:{x xdesc .qchk.chkW y};
.q.ch_not:{if[-11=type x;.qchk.err"access to hdel is denied"]; not x};
.q.ch_pj:{pj[x;.qchk.chkR y]};
.q.ch_wj:{[x1;x2;x3;x4] wj[x1;x2;x3;enlist[t],.qchk.chkExpr[;cols t:x4 0]each 1_x4]};
.q.ch_wj1:{[x1;x2;x3;x4] wj1[x1;x2;x3;enlist[t],.qchk.chkExpr[;cols t:x4 0]each 1_x4]};
.q.ch_app:{.qchk.chkR .qchk.chkH x};
.q.ch_adv:{.qchk.chkH .qchk.chkR x};
.q.ch_comp:{(')[.qchk.chkH .qchk.chkR x;.qchk.chkH .qchk.chkR y]};
.q.ch_sql:{$[6=count x;.qchk.chkRTSQL . x;3=count x;.qchk.chkRTSQL[x 0]. x[1] x 2;'"rank"]} enlist ::;
.q.ch_system:{x,:(); $[x~(),"a";tables[];x~(),"f";.qchk.chkRFlt system "f";[.qchk.err"access to system is denied";system x]]};

.qchk.dummy:(`$())!();
.qchk.chkExpr:{[e;l]$[0=count e;e;0=t:type e;.qchk.chkCall[e;l];11=t;$[1=count e;e;.qchk.addApp .qchk.chkNameR[;l] each e];-11=t;.qchk.chkNameR[e;l];98>t;e;100>t;.z.s[.qchk.ve e;l];112>t;.qchk.chkFn[e;l];[.qchk.err"access denied to ",.Q.s1 e;e]]};
.qchk.chkCall:{[e;l]$[(1=c:count e)&11=type e0:e 0;e;((c>3)&e0~($))|any e0~/:`do`while`if;e0,.qchk.chk0[.qchk.chkExpr;1_e;l];any e0~/:(?;!);.qchk.chkSQL[e;l];any e0~/:(@;.);.qchk.ifnMap[e0~(.);0|3&c-2][],.qchk.chk0[.qchk.chkExpr;1_e;l];
  (c=3)&$[101=type e0;20>value e0;e0~(:)];.qchk.chkAssign[e;l];103=type e0;[v:.qchk.chk0[.qchk.chkExpr;1_e;l];$[2=c;(e0;(ch_adv),v);(3=c)&(')~e0;(ch_comp),v;'"bad adverb"]];.qchk.addApp .qchk.chk0[.qchk.chkExpr;e;l]]};
.qchk.chkFn:{[e;l]$[not null n:.q?e;$[null v:.qchk.QMap n;[.qchk.err"access denied: ",string n;e];v];e in(<>;<=;>=);e;(t:type e)in 101 102h;e;103=t;({x ch_adv y};e);100<>type e;.qchk.chkExpr[.qchk.ve e;l];.qchk.chkUserFn[e;l]]};
.qchk.chkUserFn:{[e;l]if[not null f:.qchk.fnMap e;:f]; if[not null first(v:value e)3;.qchk.err"non default namespaces are not allowed: ",.Q.s1 e]; :.qchk.fnMap[e]:.qchk.razeFn[v 1].qchk.chkExpr[.qchk.pf e;(raze v 1 2)except`]};
.qchk.chkSQL:{[e;l] s:(?)~e 0; $[4>c:count e;enlist[(ch_find;ch_lsq)(!)~e 0],.qchk.chk0[.qchk.chkExpr;1_e;l];4=c;$[s;enlist[ch_exec],.qchk.chk0[.qchk.chkExpr;1_e;l];'"rank"];5=c;.qchk.chkSExp[e;l];'"rank"]};
/ SQL expressions get converted into a) (ch_sql;get locals expr;select or update flag;table expr;a1;a2;a3) or b) (ch_sql;get locals expr;{(sel/upd flag;x;a1;a2;a3)};table expr)
/ the first option consumes a lot of bytecodes and may cause 'branch errors thus though it is more straightforward it is used only for functional selects/upds which args are already
/ complex expressions unlike literal selects where args are preparsed constants. Locals are calculated only when needed. These strange constructions are needed because the SQL statement
/ has access to locals only when it is literally ?[a;b;c;d] and we need 'a' to find out column names to check other args for invalid vars.
.qchk.chkSExp:{[e;l] isF:all v:{$[(1=count x)&0=t:type x;0;99=t;0;104=type(1;x);2;1]}each e; s:(?)~e 0; (ch_sql;$[(all 2>v)&count l;(?;`.qchk.dummy;();();({x!x:(),x};enlist l));()]),$[isF;s,.qchk.chk0[.qchk.chkExpr;1_e;l];
  (value "{(",string[s],";x;",(";"sv .qchk.mkSExp each 2_e),")}";.qchk.chkExpr[e 1;l])]};
.qchk.mkSExp:{.qchk.razeExp .qchk.ve $[(type[x]in 0 11h)&1=count x;x 0;x]}
.qchk.chkAssign:{[e;l]if[not -11=type v:first e 1;.qchk.err"unexpected var in assign: ",.Q.s1 v]; if[not e[0] in .qchk.as;.qchk.err"unsupported assign to ",string v]; .qchk.chkNameW[v;l]; (e 0;$[-11=type v;v;v,1_.qchk.chkExpr[e 1;l]];.qchk.chkExpr[e 2;l])};
.qchk.chk0:{[f;e;l] i:where 104=type each(1;)each e; @[f[;l]each e;i;{.qchk.mv}]};
.qchk.addApp:{$[1<count x;$[(t:type x 0)in 0 11 -11h;enlist[(ch_app;x 0)],1_x;t in -6 -7h;[.qchk.err"access to handles is denied";x];x];x]};
.qchk.ifnMap:(({ch_at2};{ch_at2};{ch_at3};{ch_at4};{'"@: rank"});({ch_dot2};{ch_dot2};{ch_dot3};{ch_dot4};{'".: rank"}));
.qchk.fnMap:{x!x}enlist(::); / processed user fns
.qchk.QMap:{x!.q x}(key .q)except``hopen`hclose`hcount`read0`read1`exit`0:`1:`2:`2::`save`load`rsave`rload`setenv`view`views`dsave; / named Q fns except denied
.qchk.QMap,:{kk:`$3_/:string k:k where(k:key .q)like"ch_*"; kk[i]!.q k i:where kk in key .q}[];
.qchk.as:(+:;-:;*:;%:;#:;~:;^:;&:;_:;=:;|:;,:;<:;>:;:;::); / good assigns
.qchk.mv:(value(1;))2;

/ runtime sql check - subst locals with values, it is ok because SQL is read only + all locals are in eval exprs, take care of types 0, 11 and -11 - need to enlist them
.qchk.chkRTSQL:{[l;s;a;b;c;d]
  l:$[0=count l;(();());(key l;value l)];
  ll:l[0],cl:`i,@[cols;a:$[s;.qchk.chkR;.qchk.chkW]a;()];
  if[count b; b:.qchk.sl[cl;l].qchk.chkExpr[b;ll]]; / where
  c:$[99=type c;.qchk.sl[cl;l]each .qchk.chkExpr[;ll] each c;.qchk.sl[cl;l].qchk.chkExpr[c;ll]]; / by
  d:$[99=type d;.qchk.sl[cl;l]each .qchk.chkExpr[;ll] each d;not[s]&11=abs type d;d;.qchk.sl[cl;l].qchk.chkExpr[d;ll]]; / what
  : ((!;?)s)[a;b;c;d];
 };
.qchk.sl:{[a;l;e] $[-11=t:type e;$[e in a;e;count[l 0]=i:l[0]?e;e;{$[type[x]in 0 11 -11h;enlist x;x]}l[1;i]];t in 0 11h;$[(ch_sql)~e 0;[e[1]:l[0]!l 1;e];.z.s[a;l]each e];e]}; / subst locals

/ handlers
.qchk.chkNameR:{[n;l] $[n in l;n;.qchk.chkR n]};
.qchk.chkNameW:{[n;l] $[n in l;n;.qchk.chkW n]};
.qchk.chkH:{if[type[x]in -6 -7h;.qchk.err "access to handles is denied"];x}; / handles
.qchk.chkR:{if[-11=type x;.qchk.err "access denied: ",string x];x}; / read access
.qchk.chkW:{if[-11=type x;.qchk.err "access denied: ",string x];x}; / write access
.qchk.chkRFlt:{raze @[.qchk.chkR;;`$()]each x}; / filter read
.qchk.err:{'x};
.qchk.check:{.qchk.chkExpr $[10=type x;.qchk.ps x;x]}; / eval is expected to evaluate the result, x - either string or expr
