SUBROUTINE d2fdz2(functn,fderiv)

use OPS_Fortran_Reference

    use OPS_CONSTANTS
    use, intrinsic :: ISO_C_BINDING

    use com_senga
    use com_ops_senga

!   *************************************************************************

!   D2FDZ2
!   ======

!   AUTHOR
!   ------
!   R.S.CANT

!   CHANGE RECORD
!   -------------
!   01-AUG-1996:  CREATED
!   11-APR-2003:  RSC MODIFIED FOR SENGA2
!   10-OCT-2004:  RSC NULL VERSION

!   DESCRIPTION
!   -----------
!   DNS CODE SENGA2
!   EVALUATES SECOND Z-DERIVATIVE OF SPECIFIED FUNCTION
!   EXPLICIT 10TH ORDER FINITE DIFFERENCE METHOD
!   EXPLICIT 8TH,6TH,4TH,2ND ORDER END CONDITIONS

!   *************************************************************************

!   ARGUMENTS
!   =========
    TYPE(ops_dat) :: functn, fderiv

!   LOCAL DATA
!   ==========
    integer(kind=4) :: rangexyz(6)

!   BEGIN
!   =====

!   =========================================================================

    IF (nzglbl == 1) THEN
        rangexyz = [1,nxglbl,1,nyglbl,1,nzglbl]
        call ops_par_loop(d2fdz2_kernel_null, "d2fdz2_null", senga_grid, 3, rangexyz, &
                        ops_arg_dat(fderiv, 1, s3d_000, "real(kind=8)", OPS_WRITE))

    ELSE
!       INTERIOR SCHEME
!       ===============

!       TENTH ORDER EXPLICIT DIFFERENCES

        rangexyz = [1,nxglbl,1,nyglbl,1,nzglbl]
        call ops_par_loop(d2fdz2_kernel_main, "d2fdz2_main_scheme", senga_grid, 3, rangexyz,  &
                        ops_arg_dat(functn, 1, s3d_p005_to_m005_z, "real(kind=8)", OPS_READ),  &
                        ops_arg_dat(fderiv, 1, s3d_000, "real(kind=8)", OPS_WRITE), &
                        ops_arg_gbl(nzglbl_ops, 1, "integer(kind=4)", OPS_READ), &
                        ops_arg_gbl(nendzl, 1, "integer(kind=4)", OPS_READ), &
                        ops_arg_gbl(nendzr, 1, "integer(kind=4)", OPS_READ), &
                        ops_arg_gbl(nbound_ops, 1, "integer(kind=4)", OPS_READ), &
                        ops_arg_idx())

    END IF

!   =========================================================================

END SUBROUTINE d2fdz2
