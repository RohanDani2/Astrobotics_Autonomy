#include "__cf_anav_real.h"
#ifndef RTW_HEADER_anav_real_cap_host_h_
#define RTW_HEADER_anav_real_cap_host_h_
#ifdef HOST_CAPI_BUILD
#include "rtw_capi.h"
#include "rtw_modelmap.h"
typedef struct { rtwCAPI_ModelMappingInfo mmi ; }
anav_real_host_DataMapInfo_T ;
#ifdef __cplusplus
extern "C" {
#endif
void anav_real_host_InitializeDataMapInfo ( anav_real_host_DataMapInfo_T *
dataMap , const char * path ) ;
#ifdef __cplusplus
}
#endif
#endif
#endif
