
faoebx5 <img src="man/figures/logo.png" align="right" alt="" width="120" />
===========================================================================

The `faoebx5` package provides tools to read, write, and update data stored in the [EBX5 database](https://www.orchestranetworks.com/product) without the need to out of the R/RStudio environment. For statisticians, it is a great advantage to work in the same statistical environment, because it lessens the development time.

Installation
------------

The latest development version can be installed from github:

``` r
install.packages("devtools")
devtools::install_github('lgsilvaesilva/faoebx5')
```

faoebx5 Example
---------------

`GetEBXCodeLists()`
-------------------

``` r
library('faoebx5')

SetEBXCredentials()
# There is already EBX credentials stored.

ebx_cl <- GetEBXCodeLists()

dim(ebx_cl)
# [1] 60  6
names(ebx_cl)
# [1] "Identifier" "Acronym"    "Folder"     "Name"       "Branch"     "Instance"

ebx_cl[1:15, ]
#     Identifier                      Acronym      Folder            Name  Branch Instance
#  1:        100    CL_FI_COMMODITY_CPC_CLASS   Commodity       CPC_Class Fishery  Fishery
#  2:        101 CL_FI_COMMODITY_CPC_DIVISION   Commodity    CPC Division Fishery  Fishery
#  3:        102    CL_FI_COMMODITY_CPC_GROUP   Commodity       CPC_Group Fishery  Fishery
#  4:        103   CL_FI_COMMODITY_FAO_LEVEL1   Commodity      FAO_Level1 Fishery  Fishery
#  5:        104   CL_FI_COMMODITY_FAO_LEVEL2   Commodity      FAO_Level2 Fishery  Fishery
#  6:        105   CL_FI_COMMODITY_FAO_LEVEL3   Commodity      FAO_Level3 Fishery  Fishery
#  7:        106  CL_FI_COMMODITY_FAOMAJOR_L1   Commodity FAOmajor_Level1 Fishery  Fishery
#  8:        107  CL_FI_COMMODITY_FAOMAJOR_L2   Commodity FAOmajor_Level2 Fishery  Fishery
#  9:        108   CL_FI_COMMODITY_FAOSTAT_L1   Commodity  FAOSTAT_Level1 Fishery  Fishery
# 10:        109   CL_FI_COMMODITY_FAOSTAT_L2   Commodity  FAOSTAT_Level2 Fishery  Fishery
# 11:        110    CL_FI_COMMODITY_HS2012_L1 HSCommodity   HS2012_Level1 Fishery  Fishery
# 12:        111    CL_FI_COMMODITY_HS2012_L2 HSCommodity   HS2012_Level2 Fishery  Fishery
# 13:        112    CL_FI_COMMODITY_HS2012_L3 HSCommodity   HS2012_Level3 Fishery  Fishery
# 14:        113       CL_FI_COMMODITY_ISSCFC   Commodity          ISSCFC Fishery  Fishery
# 15:        114        CL_FI_COMMODITY_SITC4   Commodity           SITC4 Fishery  Fishery
```

`ReadEBXCodeList()`
-------------------

``` r

cl_isscfc <- ReadEBXCodeList(cl_name = 'ISSCFC')
head(cl_isscfc)
#    Identifier           Code Observations funcISSCFCparent ISSCAAPmapping HS2017mapping
# 1:          1   034.1.5.1.50         true        034.1.5.1             31       0302.29
# 2:          2   034.1.5.2.45         true        034.1.5.2             32       0302.55
# 3:          3 034.4.1.5.3.80         true      034.4.1.5.3             33       0304.89
# 4:          4   034.1.2.1.30         true        034.1.2.1             23       0301.91
# 5:          5   034.1.2.1.90         true        034.1.2.1             39       0301.99
# 6:          6   034.1.1.2.90         true        034.1.1.2             39       0301.99
#    SITC4mapping funcCPCmapping                                       NameEn
# 1:       034.13            423                   Flounder, fresh or chilled
# 2:       034.18            424             Alaska pollock, fresh or chilled
# 3:        034.4          21222                Atka mackerel fillets, frozen
# 4:       034.11            422                        Trouts and chars live
# 5:       034.11            429                               Fish live, nei
# 6:       034.11            419 Fish for culture incl. ova, fingerlings etc.
#                                            NameFr                                      NameEs
# 1:                       Flet, frais ou réfrigéré               Platija, fresca o refrigerada
# 2:              Lieu d'Alaska, frais ou réfrigéré       Colín de Alaska, fresco o refrigerado
# 3:           Filets de maquereau d'Atka, congelés        Lorcha de Atka en filetes, congelada
# 4:                     Truites et ombles, vivants                               Truchas vivas
# 5:                            Poisson vivant, nca                            Peces vivos, nep
# 6: Poissons pour l'élevage incl. oeufs, frai etc. Peces para cultivo incl. huevas, crias etc.
```
