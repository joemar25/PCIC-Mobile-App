// src/utils/seeds/_corn_dropdown.dart
class Corn {
  static int _idCounter = 0;

  final int id;
  final String title;

  Corn({
    required this.id,
    required this.title,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
    };
  }

  factory Corn.fromMap(Map<String, dynamic> map) {
    return Corn(
      id: map['id'],
      title: map['title'],
    );
  }

  static Corn createSeed({required String title}) {
    final seed = Corn(id: _idCounter++, title: title);
    return seed;
  }

  static List<Corn> getAllSeeds() {
    return [
      Corn.createSeed(title: """PSB Cn-5 /P-3278 (Y8 G-61)"""),
      Corn.createSeed(title: """PSB Cn-4 /SX 767 (CPX 312) hybrid"""),
      Corn.createSeed(title: """PSB Cn-7 /CPX 912 (CPX 912) hybrid"""),
      Corn.createSeed(title: """PSB Cn-9 /P-3234 (Y8 G-66) hybrid"""),
      Corn.createSeed(title: """PSB Cn-2 /P-3262"""),
      Corn.createSeed(title: """IPB Var 1E      - PSB Cn 90-1 IPB Var 5"""),
      Corn.createSeed(title: """PSB Cn-3 /VM-2 (VISCA 8550)"""),
      Corn.createSeed(title: """PSB Cn-6 /SMC E-25 (SMC E-25) hybrid"""),
      Corn.createSeed(title: """PSB Cn-8 /US Var 6 (USMARC 2088)"""),
      Corn.createSeed(title: """Cargill 747"""),
      Corn.createSeed(title: """PSB Cn-1 /IPB Var 5 (IES Var 1E)"""),
      Corn.createSeed(title: """Y8 G-61              - PSBCn 90-5 P 3278"""),
      Corn.createSeed(title: """VISCA 8550    - PSB Cn 90-2 IPB VM 2"""),
      Corn.createSeed(title: """CPX-811             - PSBCn 90-4 SX 767"""),
      Corn.createSeed(title: """Y8 G-66              - PSBCn 90-9 P-3234"""),
      Corn.createSeed(title: """CPX 912     - PSB Cn 90-7 CPX 912 CX 777"""),
      Corn.createSeed(title: """Y9-69 (P78930)   - PSBCn 90-2 P-3262"""),
      Corn.createSeed(title: """SMC E-25           - PSBCn 90-6 SMC E-25"""),
      Corn.createSeed(title: """USMARC 2088    - PSB Cn90-8 USM Var 6"""),
      Corn.createSeed(title: """IES Glut. #1 IES Cn1  - PSB Cn12"""),
      Corn.createSeed(title: """PSB Cn-12 (IES Glut#1 IES Cn1)"""),
      Corn.createSeed(title: """PSB Cn-13 (IPB Macapuno)"""),
      Corn.createSeed(title: """PSB Cn 94-52 (IPAS054)"""),
      Corn.createSeed(title: """7PASO54 PSB CN-52"""),
      Corn.createSeed(title: """8PASO23 PSB CN-53"""),
      Corn.createSeed(title: """Hybrid"""),
      Corn.createSeed(title: """Yellow"""),
      Corn.createSeed(title: """Phil DMR Comp 1"""),
      Corn.createSeed(title: """IES Cn2 ""Isabela White Corn 2"" (IES Var2)"""),
      Corn.createSeed(title: """PSB Cn-16 (CPX 1014) hybrid"""),
      Corn.createSeed(title: """IES Var 8   - IES Cn2 (Isabela White Corn2)"""),
      Corn.createSeed(title: """PSB Cn-18 (YOF 62) pioneer/hybrid"""),
      Corn.createSeed(title: """PSB Cn-20 (USMARC 1888)"""),
      Corn.createSeed(title: """PSB Cn-21 (USMARC 1888)"""),
      Corn.createSeed(title: """PSB Cn-11 (CPX 921) hybrid"""),
      Corn.createSeed(title: """PSB Cn-15 (CPX 1012) hybrid"""),
      Corn.createSeed(title: """PSB Cn-19 (USMARC 1887)"""),
      Corn.createSeed(title: """PSB Cn-10 (AP 4)"""),
      Corn.createSeed(title: """PSB Cn-14 (CPX 1011) hybrid"""),
      Corn.createSeed(title: """Cornworld 18"""),
      Corn.createSeed(title: """Cargill 711"""),
      Corn.createSeed(title: """PSB Cn 95-61 (IES Cn4)"""),
      Corn.createSeed(title: """PSB Cn 95-62 (IPB (911)"""),
      Corn.createSeed(title: """PSB Cn 95-63 (IPB 9204)"""),
      Corn.createSeed(title: """PSB Cn 95-64 (BS 9754)"""),
      Corn.createSeed(title: """PSB Cn 95-65 (FE 827)"""),
      Corn.createSeed(title: """PSB Cn 95-66 (FE 820)"""),
      Corn.createSeed(title: """PSB Cn-32 (IES Cn3)"""),
      Corn.createSeed(title: """PSB Cn-17 (7PG238 P 3014) pioneer/hybrid"""),
      Corn.createSeed(title: """SC 111                     - PSB Cn-48"""),
      Corn.createSeed(title: """PSB Cn-42 (CPX3122)"""),
      Corn.createSeed(title: """PSB Cn-45 (CTH501)"""),
      Corn.createSeed(title: """PSB Cn-49 (DLU Pearl Sweet)"""),
      Corn.createSeed(title: """PSB Cn-28 (IES Cn6)"""),
      Corn.createSeed(title: """PSB Cn 94-55 (C-520A or CPX 520X)"""),
      Corn.createSeed(title: """PSB Cn-48 (SC111)"""),
      Corn.createSeed(title: """CPX 1014 (CPX 3905)  - PSB Cn-16"""),
      Corn.createSeed(title: """IPB Var 7 (Dafrosa)     - PSB Cn-35"""),
      Corn.createSeed(title: """PSB Cn-26 (IES E02)"""),
      Corn.createSeed(title: """PSB Cn-35 (YOF-61)"""),
      Corn.createSeed(title: """(YOP 62) P3026 PSB CN-18"""),
      Corn.createSeed(title: """USMARC 1887     - PSB Cn20"""),
      Corn.createSeed(title: """USMARC 1388   - PSB Cn21"""),
      Corn.createSeed(
          title: """AP-4                   - PSB Cn 10 IPB Var 4"""),
      Corn.createSeed(title: """IES Cn 3             - PSB Cn-32"""),
      Corn.createSeed(title: """CPX 3122           - PSB Cn-42"""),
      Corn.createSeed(title: """CPX 921             - PSB Cn-11"""),
      Corn.createSeed(title: """CPX 1012           - PSB Cn-15"""),
      Corn.createSeed(title: """CPX 1011           - PSB Cn-14"""),
      Corn.createSeed(title: """PSB Cn-43 (MX8190)"""),
      Corn.createSeed(title: """PSB Cn-29 (CMU Var2)"""),
      Corn.createSeed(title: """PSB Cn-41 (MX8336)"""),
      Corn.createSeed(title: """SMC 323 (SMC-E19) hybrid"""),
      Corn.createSeed(title: """SMC Hi-yield 305"""),
      Corn.createSeed(title: """Phil DMR Comp 2"""),
      Corn.createSeed(title: """MIT2"""),
      Corn.createSeed(title: """SMC Hi-yield 305 (SMC 305) hybrid"""),
      Corn.createSeed(title: """USMARC1887             - PSB Cn-19"""),
      Corn.createSeed(title: """(7PG6238) P 3014 PSB CN-17"""),
      Corn.createSeed(title: """IES (Cn 4) (OPV White)  - Cn 95-61"""),
      Corn.createSeed(title: """IES EO2                       - PSB Cn-26"""),
      Corn.createSeed(title: """CPX 612             - CSX-767"""),
      Corn.createSeed(title: """P 3246 (YIG68)(7PG137) - PSB Cn-33"""),
      Corn.createSeed(title: """Pioneer XCG33"""),
      Corn.createSeed(title: """PSB Cn-39 (XCW11)"""),
      Corn.createSeed(title: """PSB Cn-33 (Pioneer 3246)"""),
      Corn.createSeed(title: """XCG-33 (P8120736) hybrid"""),
      Corn.createSeed(title: """SMC Hi-yield 102"""),
      Corn.createSeed(title: """SMC Hi-yield 152"""),
      Corn.createSeed(title: """SMC Hi-yield 301"""),
      Corn.createSeed(title: """SMC Hi-yield 301 (SMC 301) hybrid"""),
      Corn.createSeed(title: """PSB Cn-22 (YIF 623) hybrid"""),
      Corn.createSeed(title: """SMC 321 (SMC-E17) hybrid"""),
      Corn.createSeed(title: """SMC Hi-yield 152 (SMC 152) hybrid"""),
      Corn.createSeed(title: """CPX 1113                    - PSB Cn-23"""),
      Corn.createSeed(title: """PSB Cn-23 (CPX 1113)"""),
      Corn.createSeed(title: """PSB Cn-25 (YOF-61)"""),
      Corn.createSeed(title: """PSB Cn-40 (XCW15)"""),
      Corn.createSeed(title: """PSB Cn 94-57 (CPX 3205)"""),
      Corn.createSeed(
          title: """PSB Cn 94-60 (P-3008 /X1420V /Y1402W 11PG0127"""),
      Corn.createSeed(title: """CSX-767 (CPX 621) hybrid"""),
      Corn.createSeed(title: """CTH 501                      - PSB Cn-45"""),
      Corn.createSeed(title: """IES Cn 6                  - PSB Cn-28"""),
      Corn.createSeed(title: """CPX 3205                     - PSB Cn-57"""),
      Corn.createSeed(title: """P-8120763          - XCG-33"""),
      Corn.createSeed(title: """XCW 11                      - PSB Cn-39"""),
      Corn.createSeed(title: """FE 817                         - Cn 95-65"""),
      Corn.createSeed(title: """USM Var 5              - PSB Cn-31"""),
      Corn.createSeed(title: """X13526(Y35261)(11PGO133) - PSB Cn-44 P3016"""),
      Corn.createSeed(title: """PSB Cn-37 (IPB 921)"""),
      Corn.createSeed(title: """PSB Cn-44 (X13526))"""),
      Corn.createSeed(title: """PSB Cn-34 (X14020)"""),
      Corn.createSeed(
          title: """IES Var 2         - IES Cn1 (Isabela Yellow)"""),
      Corn.createSeed(title: """PSB Cn-47 (CW 18)"""),
      Corn.createSeed(title: """IES Cn1 ""Isabela Yellow"" (IES Var2)"""),
      Corn.createSeed(title: """PSB Cn-38 (IPB 929)"""),
      Corn.createSeed(title: """PSB Cn-27 (USM Var 10)"""),
      Corn.createSeed(title: """IPB Var 2"""),
      Corn.createSeed(title: """UPL Cn-2 Tanco white (IPB Var 2)"""),
      Corn.createSeed(title: """PSB Cn 94-54 (FE815)"""),
      Corn.createSeed(title: """PSB Cn-31 (USM var5)"""),
      Corn.createSeed(title: """P-3008(C1402V/Y1402V/11PG0127) - PSB Cn-60"""),
      Corn.createSeed(title: """FE 820                         - Cn 95-66"""),
      Corn.createSeed(title: """MX 8190                      - PSB Cn-43"""),
      Corn.createSeed(title: """CMU Var 2             - PSB"""),
      Corn.createSeed(title: """SMC 301      - SMC HI-YIELD 305"""),
      Corn.createSeed(title: """X1402U (Y1402U)(10PG010) - PSB Cn-34"""),
      Corn.createSeed(title: """IPB-921                       - PSB Cn-37"""),
      Corn.createSeed(title: """SMC 153            - SMC HI-YIELD 153"""),
      Corn.createSeed(title: """USMARC Var 9        - PSB Cn-51"""),
      Corn.createSeed(title: """SMC Hi-yield 153 (SMC 153) hybrid"""),
      Corn.createSeed(title: """Cargill SX 747 (C 6385) hybrid"""),
      Corn.createSeed(title: """Cargill CS 711 (CE-1) hybrid"""),
      Corn.createSeed(title: """PSB Cn-30 (USM Var3)"""),
      Corn.createSeed(title: """P3228 (2H 113) hybrid"""),
      Corn.createSeed(title: """PSB Cn 94-51 (USM Var 7 SMARC 1191)"""),
      Corn.createSeed(title: """SMC-E19            - SMC-323"""),
      Corn.createSeed(title: """MX 8336                     - PSB Cn-41"""),
      Corn.createSeed(title: """BS 9754                       - Cn 95-64"""),
      Corn.createSeed(title: """C-520A (CPX520A)      - PSB Cn-55"""),
      Corn.createSeed(title: """CW                              -PSB Cn-47"""),
      Corn.createSeed(title: """IPB 911                     - Cn 95-62"""),
      Corn.createSeed(title: """CW                              -PSB Cn-46"""),
      Corn.createSeed(title: """PSB Cn-46 (CW 16)"""),
      Corn.createSeed(title: """SMC Hi-yield 201(SMC 201) hybrid"""),
      Corn.createSeed(title: """Hycorn 9"""),
      Corn.createSeed(title: """Pioneer 6181"""),
      Corn.createSeed(title: """SMC 305            - SMC HI-YIELD 305"""),
      Corn.createSeed(title: """SMC 152            - SMC HI-YIELD 152"""),
      Corn.createSeed(title: """SMC 201            - SMC HI-YIELD 201"""),
      Corn.createSeed(title: """SMC-E17            - SMC-321"""),
      Corn.createSeed(title: """YIF 62 P-3022 W         - PSB Cn-20"""),
      Corn.createSeed(title: """IPB-929                       - PSB Cn-38"""),
      Corn.createSeed(title: """IPB 9204                   - Cn 95-63"""),
      Corn.createSeed(title: """CE-1                  - Cargill-CS 711"""),
      Corn.createSeed(title: """C 6385               - Cargill-SX 747"""),
      Corn.createSeed(title: """SMC-E9              - SMC-319"""),
      Corn.createSeed(title: """SMC Hi-yield 103"""),
      Corn.createSeed(title: """CX 757 (CPX 613) hybrid"""),
      Corn.createSeed(title: """Phil DMR 2"""),
      Corn.createSeed(title: """Phil DNR 2"""),
      Corn.createSeed(title: """PSB Cn 94-59 (CPX 3007)"""),
      Corn.createSeed(title: """SMC 319 (SMC-E9) hybrid"""),
      Corn.createSeed(title: """AH 193 or FE 815         - PSB Cn-54"""),
      Corn.createSeed(title: """CPX 3007                     - PSB Cn-59"""),
      Corn.createSeed(title: """PSB Cn-36 (IPB 919)"""),
      Corn.createSeed(title: """P3274 (2H 106) hybrid pioneer"""),
      Corn.createSeed(title: """Cargill 200"""),
      Corn.createSeed(title: """USM Var 10             - PSB"""),
      Corn.createSeed(title: """2H 13 P-3228"""),
      Corn.createSeed(title: """P3208 (3H 208) hybrid pioneer"""),
      Corn.createSeed(title: """SMC 308 (S-E2) hybrid"""),
      Corn.createSeed(title: """Cargill 100"""),
      Corn.createSeed(title: """P3224 (3H 201) hybrid"""),
      Corn.createSeed(title: """PSB Cn 94-56 (C-900M or C 900)"""),
      Corn.createSeed(
          title: """PSB Cn 94-50 (BPI LG COMP 1 or LG COMP 1-91)"""),
      Corn.createSeed(title: """CPX 621             - CSX-767"""),
      Corn.createSeed(title: """C-900M                        - PSB Cn-56"""),
      Corn.createSeed(
          title: """BP LG Comp 1 (LG Comp 1-91)       - PSB Cn-50"""),
      Corn.createSeed(title: """SMC Hi-yield 309"""),
      Corn.createSeed(title: """SMC Hi-yield 309 (SMC 309) hybrid"""),
      Corn.createSeed(title: """SMC 317 (S-E3) hybrid"""),
      Corn.createSeed(title: """(YOF-61) P 3400 PSB CN-25"""),
      Corn.createSeed(title: """IPB-919                       - PSB Cn-36"""),
      Corn.createSeed(title: """SMARC 1283   - SMARC 1283"""),
      Corn.createSeed(title: """SMC 308 (SMARC 1283)"""),
      Corn.createSeed(title: """PSB Cn-24 (IPBXH913)"""),
      Corn.createSeed(title: """PSB Cn 94-58 (PAC 1358 or ICI 1358)"""),
      Corn.createSeed(title: """S E2                    - SMC 308"""),
      Corn.createSeed(title: """PAC 1358                     - PSB Cn-58"""),
      Corn.createSeed(title: """SMC 309            - SMC HI-YIELD 309"""),
      Corn.createSeed(title: """IBB"""),
      Corn.createSeed(title: """UPCA Var 1"""),
      Corn.createSeed(title: """UPCA Var 2"""),
      Corn.createSeed(title: """BPI Var 1"""),
      Corn.createSeed(title: """IPB Var 1"""),
      Corn.createSeed(title: """IPB Var 1 913"""),
      Corn.createSeed(title: """2H 106 P-3274"""),
      Corn.createSeed(title: """IPB Var2      - UPLB Cn-2 Tanco White"""),
      Corn.createSeed(title: """3H 201 P-3224"""),
      Corn.createSeed(title: """S-E3                   - SMC 317"""),
      Corn.createSeed(title: """IPBXH 913                  - PBS Cn-24"""),
      Corn.createSeed(title: """3H 208 P-3208"""),
      Corn.createSeed(title: """XCW 15  - PSB Cn-40"""),
      Corn.createSeed(title: """USMARC 104          - PSB Cn-01"""),
      Corn.createSeed(title: """PSB Cn-01 (USMARC 104)"""),
      Corn.createSeed(title: """Cornworld (CW1)/ Cargill 909"""),
      Corn.createSeed(title: """Cornworld (CW)/ Cargill 818"""),
      Corn.createSeed(title: """Cornworld (CW) 58"""),
      Corn.createSeed(title: """Hybrid 3013"""),
      Corn.createSeed(title: """Hybrid 3014"""),
      Corn.createSeed(title: """Hybrid 3065"""),
      Corn.createSeed(title: """Pioneer 3161"""),
      Corn.createSeed(title: """CORN 110 DAYS"""),
      Corn.createSeed(title: """CORN 100 DAYS"""),
      Corn.createSeed(title: """CORN 120 DAYS"""),
      Corn.createSeed(title: """DEKALB 9132"""),
    ];
  }
}
