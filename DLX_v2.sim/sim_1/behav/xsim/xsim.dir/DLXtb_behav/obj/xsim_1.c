/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                         */
/*  \   \        Copyright (c) 2003-2013 Xilinx, Inc.                 */
/*  /   /        All Right Reserved.                                  */
/* /---/   /\                                                         */
/* \   \  /  \                                                        */
/*  \___\/\___\                                                       */
/**********************************************************************/


#include "iki.h"
#include <string.h>
#include <math.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                         */
/*  \   \        Copyright (c) 2003-2013 Xilinx, Inc.                 */
/*  /   /        All Right Reserved.                                  */
/* /---/   /\                                                         */
/* \   \  /  \                                                        */
/*  \___\/\___\                                                       */
/**********************************************************************/


#include "iki.h"
#include <string.h>
#include <math.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
typedef void (*funcp)(char *, char *);
extern int main(int, char**);
extern void execute_580(char*, char *);
extern void execute_581(char*, char *);
extern void execute_582(char*, char *);
extern void execute_583(char*, char *);
extern void execute_584(char*, char *);
extern void execute_585(char*, char *);
extern void execute_586(char*, char *);
extern void execute_587(char*, char *);
extern void execute_588(char*, char *);
extern void execute_589(char*, char *);
extern void execute_590(char*, char *);
extern void execute_591(char*, char *);
extern void execute_592(char*, char *);
extern void execute_593(char*, char *);
extern void execute_594(char*, char *);
extern void execute_78(char*, char *);
extern void execute_79(char*, char *);
extern void execute_84(char*, char *);
extern void execute_89(char*, char *);
extern void execute_90(char*, char *);
extern void execute_91(char*, char *);
extern void execute_92(char*, char *);
extern void execute_93(char*, char *);
extern void execute_544(char*, char *);
extern void execute_555(char*, char *);
extern void execute_556(char*, char *);
extern void execute_54(char*, char *);
extern void execute_55(char*, char *);
extern void execute_56(char*, char *);
extern void execute_57(char*, char *);
extern void execute_58(char*, char *);
extern void execute_59(char*, char *);
extern void execute_60(char*, char *);
extern void execute_61(char*, char *);
extern void execute_62(char*, char *);
extern void execute_63(char*, char *);
extern void execute_64(char*, char *);
extern void execute_65(char*, char *);
extern void execute_66(char*, char *);
extern void execute_67(char*, char *);
extern void execute_68(char*, char *);
extern void execute_69(char*, char *);
extern void execute_70(char*, char *);
extern void execute_71(char*, char *);
extern void execute_72(char*, char *);
extern void execute_73(char*, char *);
extern void execute_75(char*, char *);
extern void execute_86(char*, char *);
extern void execute_88(char*, char *);
extern void execute_103(char*, char *);
extern void execute_105(char*, char *);
extern void execute_113(char*, char *);
extern void execute_116(char*, char *);
extern void execute_117(char*, char *);
extern void execute_118(char*, char *);
extern void execute_543(char*, char *);
extern void execute_188(char*, char *);
extern void execute_189(char*, char *);
extern void execute_190(char*, char *);
extern void execute_191(char*, char *);
extern void execute_460(char*, char *);
extern void execute_124(char*, char *);
extern void execute_126(char*, char *);
extern void execute_128(char*, char *);
extern void execute_130(char*, char *);
extern void execute_132(char*, char *);
extern void execute_134(char*, char *);
extern void execute_136(char*, char *);
extern void execute_138(char*, char *);
extern void execute_140(char*, char *);
extern void execute_142(char*, char *);
extern void execute_144(char*, char *);
extern void execute_146(char*, char *);
extern void execute_148(char*, char *);
extern void execute_150(char*, char *);
extern void execute_152(char*, char *);
extern void execute_154(char*, char *);
extern void execute_156(char*, char *);
extern void execute_158(char*, char *);
extern void execute_160(char*, char *);
extern void execute_162(char*, char *);
extern void execute_164(char*, char *);
extern void execute_166(char*, char *);
extern void execute_168(char*, char *);
extern void execute_170(char*, char *);
extern void execute_172(char*, char *);
extern void execute_174(char*, char *);
extern void execute_176(char*, char *);
extern void execute_178(char*, char *);
extern void execute_180(char*, char *);
extern void execute_182(char*, char *);
extern void execute_184(char*, char *);
extern void execute_186(char*, char *);
extern void execute_193(char*, char *);
extern void execute_194(char*, char *);
extern void execute_196(char*, char *);
extern void execute_197(char*, char *);
extern void execute_199(char*, char *);
extern void execute_200(char*, char *);
extern void execute_202(char*, char *);
extern void execute_203(char*, char *);
extern void execute_205(char*, char *);
extern void execute_206(char*, char *);
extern void execute_208(char*, char *);
extern void execute_209(char*, char *);
extern void execute_211(char*, char *);
extern void execute_212(char*, char *);
extern void execute_214(char*, char *);
extern void execute_215(char*, char *);
extern void execute_217(char*, char *);
extern void execute_218(char*, char *);
extern void execute_220(char*, char *);
extern void execute_221(char*, char *);
extern void execute_223(char*, char *);
extern void execute_224(char*, char *);
extern void execute_226(char*, char *);
extern void execute_227(char*, char *);
extern void execute_229(char*, char *);
extern void execute_230(char*, char *);
extern void execute_232(char*, char *);
extern void execute_233(char*, char *);
extern void execute_235(char*, char *);
extern void execute_236(char*, char *);
extern void execute_238(char*, char *);
extern void execute_239(char*, char *);
extern void execute_241(char*, char *);
extern void execute_242(char*, char *);
extern void execute_244(char*, char *);
extern void execute_245(char*, char *);
extern void execute_247(char*, char *);
extern void execute_248(char*, char *);
extern void execute_250(char*, char *);
extern void execute_251(char*, char *);
extern void execute_253(char*, char *);
extern void execute_254(char*, char *);
extern void execute_256(char*, char *);
extern void execute_257(char*, char *);
extern void execute_259(char*, char *);
extern void execute_260(char*, char *);
extern void execute_262(char*, char *);
extern void execute_263(char*, char *);
extern void execute_265(char*, char *);
extern void execute_266(char*, char *);
extern void execute_268(char*, char *);
extern void execute_269(char*, char *);
extern void execute_271(char*, char *);
extern void execute_272(char*, char *);
extern void execute_274(char*, char *);
extern void execute_275(char*, char *);
extern void execute_277(char*, char *);
extern void execute_278(char*, char *);
extern void execute_280(char*, char *);
extern void execute_281(char*, char *);
extern void execute_283(char*, char *);
extern void execute_284(char*, char *);
extern void execute_338(char*, char *);
extern void execute_386(char*, char *);
extern void execute_387(char*, char *);
extern void execute_388(char*, char *);
extern void execute_287(char*, char *);
extern void execute_289(char*, char *);
extern void execute_462(char*, char *);
extern void execute_463(char*, char *);
extern void execute_464(char*, char *);
extern void execute_465(char*, char *);
extern void execute_466(char*, char *);
extern void execute_467(char*, char *);
extern void execute_468(char*, char *);
extern void execute_470(char*, char *);
extern void execute_534(char*, char *);
extern void execute_535(char*, char *);
extern void execute_536(char*, char *);
extern void execute_537(char*, char *);
extern void execute_538(char*, char *);
extern void execute_539(char*, char *);
extern void execute_540(char*, char *);
extern void execute_541(char*, char *);
extern void execute_542(char*, char *);
extern void execute_472(char*, char *);
extern void execute_474(char*, char *);
extern void execute_476(char*, char *);
extern void execute_478(char*, char *);
extern void execute_480(char*, char *);
extern void execute_482(char*, char *);
extern void execute_484(char*, char *);
extern void execute_486(char*, char *);
extern void execute_488(char*, char *);
extern void execute_490(char*, char *);
extern void execute_492(char*, char *);
extern void execute_494(char*, char *);
extern void execute_496(char*, char *);
extern void execute_498(char*, char *);
extern void execute_500(char*, char *);
extern void execute_502(char*, char *);
extern void execute_504(char*, char *);
extern void execute_506(char*, char *);
extern void execute_508(char*, char *);
extern void execute_510(char*, char *);
extern void execute_512(char*, char *);
extern void execute_514(char*, char *);
extern void execute_516(char*, char *);
extern void execute_518(char*, char *);
extern void execute_520(char*, char *);
extern void execute_522(char*, char *);
extern void execute_524(char*, char *);
extern void execute_526(char*, char *);
extern void execute_528(char*, char *);
extern void execute_530(char*, char *);
extern void execute_532(char*, char *);
extern void execute_546(char*, char *);
extern void execute_572(char*, char *);
extern void execute_574(char*, char *);
extern void execute_575(char*, char *);
extern void execute_576(char*, char *);
extern void execute_578(char*, char *);
extern void execute_579(char*, char *);
extern void transaction_0(char*, char*, unsigned, unsigned, unsigned);
extern void vhdl_transfunc_eventcallback(char*, char*, unsigned, unsigned, unsigned, char *);
extern void transaction_20(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_35(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_44(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_54(char*, char*, unsigned, unsigned, unsigned);
funcp funcTab[222] = {(funcp)execute_580, (funcp)execute_581, (funcp)execute_582, (funcp)execute_583, (funcp)execute_584, (funcp)execute_585, (funcp)execute_586, (funcp)execute_587, (funcp)execute_588, (funcp)execute_589, (funcp)execute_590, (funcp)execute_591, (funcp)execute_592, (funcp)execute_593, (funcp)execute_594, (funcp)execute_78, (funcp)execute_79, (funcp)execute_84, (funcp)execute_89, (funcp)execute_90, (funcp)execute_91, (funcp)execute_92, (funcp)execute_93, (funcp)execute_544, (funcp)execute_555, (funcp)execute_556, (funcp)execute_54, (funcp)execute_55, (funcp)execute_56, (funcp)execute_57, (funcp)execute_58, (funcp)execute_59, (funcp)execute_60, (funcp)execute_61, (funcp)execute_62, (funcp)execute_63, (funcp)execute_64, (funcp)execute_65, (funcp)execute_66, (funcp)execute_67, (funcp)execute_68, (funcp)execute_69, (funcp)execute_70, (funcp)execute_71, (funcp)execute_72, (funcp)execute_73, (funcp)execute_75, (funcp)execute_86, (funcp)execute_88, (funcp)execute_103, (funcp)execute_105, (funcp)execute_113, (funcp)execute_116, (funcp)execute_117, (funcp)execute_118, (funcp)execute_543, (funcp)execute_188, (funcp)execute_189, (funcp)execute_190, (funcp)execute_191, (funcp)execute_460, (funcp)execute_124, (funcp)execute_126, (funcp)execute_128, (funcp)execute_130, (funcp)execute_132, (funcp)execute_134, (funcp)execute_136, (funcp)execute_138, (funcp)execute_140, (funcp)execute_142, (funcp)execute_144, (funcp)execute_146, (funcp)execute_148, (funcp)execute_150, (funcp)execute_152, (funcp)execute_154, (funcp)execute_156, (funcp)execute_158, (funcp)execute_160, (funcp)execute_162, (funcp)execute_164, (funcp)execute_166, (funcp)execute_168, (funcp)execute_170, (funcp)execute_172, (funcp)execute_174, (funcp)execute_176, (funcp)execute_178, (funcp)execute_180, (funcp)execute_182, (funcp)execute_184, (funcp)execute_186, (funcp)execute_193, (funcp)execute_194, (funcp)execute_196, (funcp)execute_197, (funcp)execute_199, (funcp)execute_200, (funcp)execute_202, (funcp)execute_203, (funcp)execute_205, (funcp)execute_206, (funcp)execute_208, (funcp)execute_209, (funcp)execute_211, (funcp)execute_212, (funcp)execute_214, (funcp)execute_215, (funcp)execute_217, (funcp)execute_218, (funcp)execute_220, (funcp)execute_221, (funcp)execute_223, (funcp)execute_224, (funcp)execute_226, (funcp)execute_227, (funcp)execute_229, (funcp)execute_230, (funcp)execute_232, (funcp)execute_233, (funcp)execute_235, (funcp)execute_236, (funcp)execute_238, (funcp)execute_239, (funcp)execute_241, (funcp)execute_242, (funcp)execute_244, (funcp)execute_245, (funcp)execute_247, (funcp)execute_248, (funcp)execute_250, (funcp)execute_251, (funcp)execute_253, (funcp)execute_254, (funcp)execute_256, (funcp)execute_257, (funcp)execute_259, (funcp)execute_260, (funcp)execute_262, (funcp)execute_263, (funcp)execute_265, (funcp)execute_266, (funcp)execute_268, (funcp)execute_269, (funcp)execute_271, (funcp)execute_272, (funcp)execute_274, (funcp)execute_275, (funcp)execute_277, (funcp)execute_278, (funcp)execute_280, (funcp)execute_281, (funcp)execute_283, (funcp)execute_284, (funcp)execute_338, (funcp)execute_386, (funcp)execute_387, (funcp)execute_388, (funcp)execute_287, (funcp)execute_289, (funcp)execute_462, (funcp)execute_463, (funcp)execute_464, (funcp)execute_465, (funcp)execute_466, (funcp)execute_467, (funcp)execute_468, (funcp)execute_470, (funcp)execute_534, (funcp)execute_535, (funcp)execute_536, (funcp)execute_537, (funcp)execute_538, (funcp)execute_539, (funcp)execute_540, (funcp)execute_541, (funcp)execute_542, (funcp)execute_472, (funcp)execute_474, (funcp)execute_476, (funcp)execute_478, (funcp)execute_480, (funcp)execute_482, (funcp)execute_484, (funcp)execute_486, (funcp)execute_488, (funcp)execute_490, (funcp)execute_492, (funcp)execute_494, (funcp)execute_496, (funcp)execute_498, (funcp)execute_500, (funcp)execute_502, (funcp)execute_504, (funcp)execute_506, (funcp)execute_508, (funcp)execute_510, (funcp)execute_512, (funcp)execute_514, (funcp)execute_516, (funcp)execute_518, (funcp)execute_520, (funcp)execute_522, (funcp)execute_524, (funcp)execute_526, (funcp)execute_528, (funcp)execute_530, (funcp)execute_532, (funcp)execute_546, (funcp)execute_572, (funcp)execute_574, (funcp)execute_575, (funcp)execute_576, (funcp)execute_578, (funcp)execute_579, (funcp)transaction_0, (funcp)vhdl_transfunc_eventcallback, (funcp)transaction_20, (funcp)transaction_35, (funcp)transaction_44, (funcp)transaction_54};
const int NumRelocateId= 222;

void relocate(char *dp)
{
	iki_relocate(dp, "xsim.dir/DLXtb_behav/xsim.reloc",  (void **)funcTab, 222);
	iki_vhdl_file_variable_register(dp + 73192);
	iki_vhdl_file_variable_register(dp + 73248);
	iki_vhdl_file_variable_register(dp + 179528);


	/*Populate the transaction function pointer field in the whole net structure */
}

void sensitize(char *dp)
{
	iki_sensitize(dp, "xsim.dir/DLXtb_behav/xsim.reloc");
}

void simulate(char *dp)
{
	iki_schedule_processes_at_time_zero(dp, "xsim.dir/DLXtb_behav/xsim.reloc");
	// Initialize Verilog nets in mixed simulation, for the cases when the value at time 0 should be propagated from the mixed language Vhdl net
	iki_execute_processes();

	// Schedule resolution functions for the multiply driven Verilog nets that have strength
	// Schedule transaction functions for the singly driven Verilog nets that have strength

}
#include "iki_bridge.h"
void relocate(char *);

void sensitize(char *);

void simulate(char *);

extern SYSTEMCLIB_IMP_DLLSPEC void local_register_implicit_channel(int, char*);
extern void implicit_HDL_SCinstatiate();

extern SYSTEMCLIB_IMP_DLLSPEC int xsim_argc_copy ;
extern SYSTEMCLIB_IMP_DLLSPEC char** xsim_argv_copy ;

int main(int argc, char **argv)
{
    iki_heap_initialize("ms", "isimmm", 0, 2147483648) ;
    iki_set_sv_type_file_path_name("xsim.dir/DLXtb_behav/xsim.svtype");
    iki_set_crvs_dump_file_path_name("xsim.dir/DLXtb_behav/xsim.crvsdump");
    void* design_handle = iki_create_design("xsim.dir/DLXtb_behav/xsim.mem", (void *)relocate, (void *)sensitize, (void *)simulate, 0, isimBridge_getWdbWriter(), 0, argc, argv);
     iki_set_rc_trial_count(100);
    (void) design_handle;
    return iki_simulate_design();
}
