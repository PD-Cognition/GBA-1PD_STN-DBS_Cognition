* Encoding: UTF-8.
### Alles basierend auf Stammtabelle_Studie1.sav

# 3/57 Pat. haben Genetik abgelehnt, 43 gen. Negative, 6 GBA, 4 LRRK2,1 PARK

FREQUENCIES VARIABLES=gba negative lrrk2 park2
  /ORDER=ANALYSIS.


### Nur GBA: ROPAD = 2 / Nur gen. Negative: ROPAD = 1

USE ALL.
COMPUTE filter_$=(ROPAD = 1).
VARIABLE LABELS filter_$ 'ROPAD = 1 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.


### Propensity Score Matching

# case ID generieren für Matching-Zuordnung
    
COMPUTE ID = $casenum.
EXECUTE.
   
# Nur Pat. mit THS und 12MFU und ROPAD

USE ALL.
COMPUTE filter_$=(Wachkraniektomie_Datum > 0 & Datum_12MFU > 0 & ROPAD > 0 ).
VARIABLE LABELS filter_$ 'Wachkraniektomie_Datum > 0 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.

USE ALL.
COMPUTE filter_$=(Wachkraniektomie_Datum > 0).
VARIABLE LABELS filter_$ 'Wachkraniektomie_Datum > 0 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.

# Matching für MoCA, Krankheitsschwere und Alter / Propensity ist mit 0.06 (6%) niedrigst-möglich

STATS PSM GROUP = gba BY = MOCA MDS_UPDRS_III_OFF Alter_bei_Testung 
    PROPENSITY=Propensity
  FUZZ=0.06 NEWDEMANDERIDVAR=partnerID SUPPLIERID=ID
  OUTPUTDS=Propensity_Matching 
/OPTIONS SAMPLEWITHREPLACEMENT=FALSE
EXACTPRIORITY=FALSE MINIMIZEMEMORY=FALSE
SHUFFLE=FALSE.


# Variablen präOP
    
DESCRIPTIVES VARIABLES=Geschlecht Alter_bei_Testung Bildungsjahre CRP_vor_OP BMI Neurofilament_Light_Protein NFL_Serum Phospho_TAU 
    Gesamt_TAU Beta_Amyloid_1_40 Beta_Amyoid_1_42 Beta_Amyloid_Ratio Beta_Amyloid_1_42_gesamtTAU_Ratio Erkrankungsdauer ROPAD
    Ch4_TIV Ch13_TIV alpha_peak SEF95 burst_suppression Propofol1_mg_kgKG Remi1_µg_kgKG Fenta1_µg_kgKG Propofol2_mg_kgKG Remi2_µg_kgKG 
    Fenta2_µg_kgKG Dauer_der_dopaminergen_Pause Dauer_Wachkraniektomie Dauer_IPG_Implantation Delirdauer Delirschwere_Gesamt
    Charlson_Komorbiditats_Index  MNA_SF BDI Starkstein_Apathie_Skala ADL PDSI QUIP_RS
    L_DOPA_Äquivalenzdosis MDS_UPDRS_I MDS_UPDRS_II MDS_UPDRS_III_ON MDS_UPDRS_III_OFF MDS_UPDRS_IV 
    Neuropsysch_Anzahl_betroffener_Domäne MOCA MOTML RTISMDRT RTIFMDRT PRMPCI PRMPCD PALTEA PALFAMS SSPFSL SSPRSL
    VRMFRDS VRMIRTC VRMDRTC MTTTIC MTTLMD MTTICMD MTTMTCMD SWMBE468 SWMS ERTTH 
  /STATISTICS=MEAN STDDEV MIN MAX.

# Variablen 1yFU
    
DESCRIPTIVES VARIABLES= Weiterempfehlung
    CKI_12MFU MNA_SF_12MFU BDI_12MFU SAS_12MFU ADL_12MFU PDSI_12MFU QUIP_12MFU 
    LEDD_12MFU UPDRS_I_12MFU UPDRS_II_12MFU UPDRS_III_stimON_medOFF_12MFU UPDRS_III_stimON_medON_12MFU 
    UPDRS_III_stimOFF_medOFF_12MFU UPDRS_III_stimOFF_medON_12MFU UPDRS_IV_12MFU 
    MOCA_12MFU MOTML_12MFU RTISMDRT_12MFU RTIFMDRT_12MFU PRMPCI_12MFU PRMPCD_12MFU PALTEA_12MFU PALFAMS_12MFU SSPFSL_12MFU SSPRSL_12MFU
    VRMFRDS_12MFU VRMIRTC_12MFU VRMDRTC_12MFU MTTTIC_12MFU MTTLMD_12MFU MTTICMD_12MFU MTTMTCMD_12MFU SWMBE468_12MFU SWMS_12MFU ERTTH_12MFU 
     /STATISTICS=MEAN STDDEV MIN MAX.

# pre/post-Differenz-Scores

DESCRIPTIVES VARIABLES=Diff_ADL Diff_UPDRSI Diff_UPDRSII Diff_UPDRSIV Diff_SAS Diff_QUIP 
    Diff_MedOFFStimON Diff_StimONOFF PDSI_Differenz Diff_LEDD LED_perc_red Diff_BDI MOCA_Differenz MoCA_change
  /STATISTICS=MEAN STDDEV MIN MAX.

DESCRIPTIVES VARIABLES=Diff_MOTML Diff_RTISMDRT Diff_RTIFMDRT Diff_PRMPCI Diff_PRMPCD Diff_PALTEA 
    Diff_PALFAMS Diff_SSPFSL Diff_SSPRSL Diff_VRMFRDS Diff_VRMIRTC Diff_VRMDRTC Diff_MTTTIC Diff_MTTLMD 
    Diff_MTTICMD Diff_MTTMTCMD Diff_SWMBE468 Diff_SWMS Diff_ERTTH
  /STATISTICS=MEAN STDDEV MIN MAX.


### Pre/post-Vergleich

NPAR TESTS
  /WILCOXON=Charlson_Komorbiditats_Index PDSI L_DOPA_Äquivalenzdosis MOCA MDS_UPDRS_I MDS_UPDRS_II MDS_UPDRS_III_OFF 
    UPDRS_III_stimON_medOFF_12MFU MDS_UPDRS_IV MNA_SF ADL BDI Starkstein_Apathie_Skala QUIP_RS WITH 
    CKI_12MFU PDSI_12MFU LEDD_12MFU MOCA_12MFU UPDRS_I_12MFU UPDRS_II_12MFU UPDRS_III_stimON_medOFF_12MFU 
    UPDRS_III_stimOFF_medOFF_12MFU UPDRS_IV_12MFU MNA_SF_12MFU ADL_12MFU BDI_12MFU SAS_12MFU QUIP_12MFU 
    (PAIRED)
  /MISSING ANALYSIS.

NPAR TESTS
  /WILCOXON=MOCA MOTML RTISMDRT RTIFMDRT PRMPCI PRMPCD PALTEA PALFAMS SSPFSL SSPRSL
    VRMFRDS VRMIRTC VRMDRTC MTTTIC MTTLMD MTTICMD MTTMTCMD SWMBE468 SWMS ERTTH  WITH 
    MOCA_12MFU MOTML_12MFU RTISMDRT_12MFU RTIFMDRT_12MFU PRMPCI_12MFU PRMPCD_12MFU PALTEA_12MFU PALFAMS_12MFU SSPFSL_12MFU SSPRSL_12MFU
    VRMFRDS_12MFU VRMIRTC_12MFU VRMDRTC_12MFU MTTTIC_12MFU MTTLMD_12MFU MTTICMD_12MFU MTTMTCMD_12MFU SWMBE468_12MFU SWMS_12MFU ERTTH_12MFU 
    (PAIRED)
  /MISSING ANALYSIS.


### Vergleich GBA (ROPAD=2) vs. neg genetik (ROPAD=1)

# präOP - Gruppenvergleich GBA und gematchte IDs

NPAR TESTS
  /M-W= Geschlecht Alter_bei_Testung Bildungsjahre CRP_vor_OP BMI Neurofilament_Light_Protein NFL_Serum Phospho_TAU 
    Gesamt_TAU Beta_Amyloid_1_40 Beta_Amyoid_1_42 Beta_Amyloid_Ratio Beta_Amyloid_1_42_gesamtTAU_Ratio Erkrankungsdauer ROPAD
    Ch4_TIV Ch13_TIV alpha_peak SEF95 burst_suppression Propofol1_mg_kgKG Remi1_µg_kgKG Fenta1_µg_kgKG Propofol2_mg_kgKG Remi2_µg_kgKG 
    Fenta2_µg_kgKG Dauer_der_dopaminergen_Pause Dauer_Wachkraniektomie Dauer_IPG_Implantation Delirdauer Delirschwere_Gesamt
    Charlson_Komorbiditats_Index  MNA_SF BDI Starkstein_Apathie_Skala ADL PDSI QUIP_RS
    L_DOPA_Äquivalenzdosis MDS_UPDRS_I MDS_UPDRS_II MDS_UPDRS_III_ON MDS_UPDRS_III_OFF MDS_UPDRS_IV 
    Neuropsysch_Anzahl_betroffener_Domäne MOCA MOTML RTISMDRT RTIFMDRT PRMPCI PRMPCD PALTEA PALFAMS SSPFSL SSPRSL
    VRMFRDS VRMIRTC VRMDRTC MTTTIC MTTLMD MTTICMD MTTMTCMD SWMBE468 SWMS ERTTH BY ROPAD(1 2)
  /MISSING ANALYSIS.

# postOP -  Gruppenvergleich GBA und gematchte IDs

NPAR TESTS
  /M-W= Weiterempfehlung
    CKI_12MFU MNA_SF_12MFU BDI_12MFU SAS_12MFU ADL_12MFU PDSI_12MFU QUIP_12MFU 
    LEDD_12MFU UPDRS_I_12MFU UPDRS_II_12MFU UPDRS_III_stimON_medOFF_12MFU UPDRS_III_stimON_medON_12MFU 
    UPDRS_III_stimOFF_medOFF_12MFU UPDRS_III_stimOFF_medON_12MFU UPDRS_IV_12MFU 
    MOCA_12MFU MOTML_12MFU RTISMDRT_12MFU RTIFMDRT_12MFU PRMPCI_12MFU PRMPCD_12MFU PALTEA_12MFU PALFAMS_12MFU SSPFSL_12MFU SSPRSL_12MFU
    VRMFRDS_12MFU VRMIRTC_12MFU VRMDRTC_12MFU MTTTIC_12MFU MTTLMD_12MFU MTTICMD_12MFU MTTMTCMD_12MFU SWMBE468_12MFU SWMS_12MFU ERTTH_12MFU  BY ROPAD(1 2)
  /MISSING ANALYSIS.

# pre/post-Differenz-Scores - Gruppenvergleich GBA und gematchte IDs
    
NPAR TESTS
  /M-W= Diff_ADL Diff_UPDRSI Diff_UPDRSII Diff_UPDRSIV Diff_SAS Diff_QUIP 
    Diff_MedOFFStimON Diff_StimONOFF PDSI_Differenz Diff_LEDD Diff_BDI MOCA_Differenz MoCA_change BY ROPAD(1 2)
  /MISSING ANALYSIS.

NPAR TESTS
  /M-W= Diff_MOTML Diff_RTISMDRT Diff_RTIFMDRT Diff_PRMPCI Diff_PRMPCD Diff_PALTEA 
    Diff_PALFAMS Diff_SSPFSL Diff_SSPRSL Diff_VRMFRDS Diff_VRMIRTC Diff_VRMDRTC Diff_MTTTIC Diff_MTTLMD 
    Diff_MTTICMD Diff_MTTMTCMD Diff_SWMBE468 Diff_SWMS BY ROPAD(1 2)
  /MISSING ANALYSIS.

NPAR TESTS
  /M-W= LED_perc_red BY ROPAD(1 2)
  /MISSING ANALYSIS.