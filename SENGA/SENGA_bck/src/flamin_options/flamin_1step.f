      SUBROUTINE FLAMIN 
 
C     *************************************************************************
C
C     FLAMIN
C     ======
C
C     AUTHOR
C     ------
C     R.S.CANT  --  CAMBRIDGE UNIVERSITY ENGINEERING DEPARTMENT
C
C     CHANGE RECORD
C     -------------
C     28-DEC-2003:  CREATED
C     08-JAN-2005:  RSC INITIAL 1D LAMINAR FLAME PROFILE
C 
C     DESCRIPTION
C     -----------
C     DNS CODE SENGA2
C     SETS INITIAL THERMOCHEMICAL FIELD
C     1D LAMINAR FLAME PROFILE (LEFT OR RIGHT FACING)
C     SPECIAL FOR 1-STEP CHEMISTRY
C     
C     *************************************************************************


C     GLOBAL DATA
C     ===========
C     -------------------------------------------------------------------------
      INCLUDE 'com_senga2.h'
C     -------------------------------------------------------------------------


C     PARAMETERS
C     ==========
C     ESTIMATED FLAME LOCATION AND THICKNESS
      DOUBLE PRECISION CLOCAT,CTHICK
      PARAMETER(CLOCAT = 5.0D-3, CTHICK = 1.0D-3)


C     FUNCTION
C     ========
      DOUBLE PRECISION ERFUNC
      EXTERNAL ERFUNC


C     LOCAL DATA
C     ==========
      DOUBLE PRECISION CRIN(1:NXSIZE)
      DOUBLE PRECISION YRINR(NSPCMX),YRINP(NSPCMX)
      DOUBLE PRECISION TRINR,TRINP
      DOUBLE PRECISION DELTAG,XCOORD,ARGMNT
      DOUBLE PRECISION FLXMAS
      INTEGER ICPROC
      INTEGER IGOFST
      INTEGER IX
      INTEGER IC,JC,KC
      INTEGER ISPEC


C     BEGIN
C     =====

C     =========================================================================

C     SPECIFY INITIAL THERMOCHEMICAL FIELD HERE
C     =========================================


C     SET PRODUCT TEMPERATURE
C     -----------------------
C     REACTANT TEMPERATURE SET IN CONTROL FILE
      TRINR = TRIN
      TRINP = 2300.0D0


C     SET SPECIES MASS FRACTIONS
C     --------------------------
C     OVERRIDE MASS FRACTION VALUES SET IN CONTROL FILE

C     REACTANTS
      YRINR(1) = ONE

      YRINR(NSPEC) = ZERO
      DO ISPEC = 1,NSPM1
        YRINR(NSPEC) = YRINR(NSPEC) + YRINR(ISPEC)
      ENDDO
      YRINR(NSPEC) = ONE - YRINR(NSPEC)

C     PRODUCTS
      YRINP(1) = ZERO

      YRINP(NSPEC) = ZERO
      DO ISPEC = 1,NSPM1
        YRINP(NSPEC) = YRINP(NSPEC) + YRINP(ISPEC)
      ENDDO
      YRINP(NSPEC) = ONE - YRINP(NSPEC)

C     WRITE TO REPORT FILE
      IF(IPROC.EQ.0)THEN

C        OPEN(UNIT=NCREPT,FILE=FNREPT,STATUS='OLD',FORM='FORMATTED')

CC       GO TO EOF
C1000    CONTINUE
C          READ(NCREPT,9000,END=1010)
C          GOTO 1000
C1010    BACKSPACE(NCREPT)

        WRITE(NCREPT,*)
        WRITE(NCREPT,*)'FLAMIN: reactant mass fractions:'
        DO ISPEC = 1,NSPEC
          WRITE(NCREPT,'(I5,1PE15.7)')ISPEC,YRINR(ISPEC)
        ENDDO
        WRITE(NCREPT,*)

        WRITE(NCREPT,*)'FLAMIN: product mass fractions:'
        DO ISPEC = 1,NSPEC
          WRITE(NCREPT,'(I5,1PE15.7)')ISPEC,YRINP(ISPEC)
        ENDDO
        WRITE(NCREPT,*)

        WRITE(NCREPT,*)'FLAMIN: reactant and product temperatures:'
        WRITE(NCREPT,'(2(1PE15.7))')TRINR,TRINP
        WRITE(NCREPT,*)

C        CLOSE(NCREPT)

      ENDIF


C     GLOBAL INDEXING
C     ---------------
      DELTAG = XGDLEN/(REAL(NXGLBL-1))

      IGOFST = 0
      DO ICPROC = 0, IXPROC-1
        IGOFST = IGOFST + NPMAPX(ICPROC)
      ENDDO


C     SET REACTION PROGRESS VARIABLE PROFILE
C     --------------------------------------
C     SIMPLE 1D LEFT-FACING ERROR FUNCTION PROFILE
      DO IC = ISTAL,ISTOL

        IX = IGOFST + IC
        XCOORD = REAL(IX-1)*DELTAG
        ARGMNT = (XCOORD-CLOCAT)/CTHICK
        CRIN(IC) = HALF*(ONE+ERFUNC(ARGMNT))

      ENDDO

CC     SIMPLE 1D RIGHT-FACING ERROR FUNCTION PROFILE
C      DO IC = ISTAL,ISTOL
C
C        IX = IGOFST + IC
C        XCOORD = REAL(IX-1)*DELTAG
C        ARGMNT = (XCOORD-CLOCAT)/CTHICK
C        CRIN(IC) = HALF*(ONE+ERFUNC(-ARGMNT))
C
C      ENDDO


C     SET SPECIES MASS FRACTION PROFILES
C     ----------------------------------
      DO ISPEC = 1, NSPM1

        DO KC = KSTAL,KSTOL
          DO JC = JSTAL,JSTOL
            DO IC = ISTAL,ISTOL

              YRUN(IC,JC,KC,ISPEC) = YRINR(ISPEC)
     +                   + CRIN(IC)*(YRINP(ISPEC) - YRINR(ISPEC))

            ENDDO
          ENDDO
        ENDDO

      ENDDO

      DO KC = KSTAL,KSTOL
        DO JC = JSTAL,JSTOL
          DO IC = ISTAL,ISTOL

            YRUN(IC,JC,KC,NSPEC) = ZERO

          ENDDO
        ENDDO
      ENDDO

      DO ISPEC = 1, NSPM1
        DO KC = KSTAL,KSTOL
          DO JC = JSTAL,JSTOL
            DO IC = ISTAL,ISTOL

              YRUN(IC,JC,KC,NSPEC) = YRUN(IC,JC,KC,NSPEC)
     +                             + YRUN(IC,JC,KC,ISPEC)

            ENDDO
          ENDDO
        ENDDO
      ENDDO

      DO KC = KSTAL,KSTOL
        DO JC = JSTAL,JSTOL
          DO IC = ISTAL,ISTOL

            YRUN(IC,JC,KC,NSPEC) = ONE - YRUN(IC,JC,KC,NSPEC)

          ENDDO
        ENDDO
      ENDDO


C     SET TEMPERATURE PROFILE
C     -----------------------
      DO KC = KSTAL,KSTOL
        DO JC = JSTAL,JSTOL
          DO IC = ISTAL,ISTOL

            TRUN(IC,JC,KC) = TRINR +  CRIN(IC)*(TRINP - TRINR)

          ENDDO
        ENDDO
      ENDDO


C     SET DENSITY PROFILE ASSUMING CONSTANT PRESSURE
C     -------------------
C     PRESSURE SET IN CONTROL FILE

      DO KC = KSTAL,KSTOL
        DO JC = JSTAL,JSTOL
          DO IC = ISTAL,ISTOL

            STORE1(IC,JC,KC) = ZERO

          ENDDO
        ENDDO
      ENDDO

      DO ISPEC = 1,NSPEC
        DO KC = KSTAL,KSTOL
          DO JC = JSTAL,JSTOL
            DO IC = ISTAL,ISTOL

              STORE1(IC,JC,KC) = STORE1(IC,JC,KC)
     +                         + RGSPEC(ISPEC)*YRUN(IC,JC,KC,ISPEC)

            ENDDO
          ENDDO
        ENDDO
      ENDDO

      DO KC = KSTAL,KSTOL
        DO JC = JSTAL,JSTOL
          DO IC = ISTAL,ISTOL

            DRUN(IC,JC,KC) = PRIN/(STORE1(IC,JC,KC)*TRUN(IC,JC,KC))

          ENDDO
        ENDDO
      ENDDO


C     SET VELOCITY PROFILE ASSUMING CONSTANT MASS FLUX
C     --------------------
C     INITIAL (INLET) VELOCITY SET IN CONTROL FILE
      FLXMAS = DRIN*URIN
      DO KC = KSTAL,KSTOL
        DO JC = JSTAL,JSTOL
          DO IC = ISTAL,ISTOL

            URUN(IC,JC,KC) = FLXMAS/DRUN(IC,JC,KC)

          ENDDO
        ENDDO
      ENDDO

C     =========================================================================


      RETURN

9000  FORMAT(A)

      END
