/*
 * sccb.h
 *
 *  Created on: Nov 10, 2018
 *      Author: deokhwan
 */

#ifndef SCCB_H_
#define SCCB_H_

#include <ppc-asm.h>
#include "xio.h"

/**************************************/
/* Definitions for peripheral SCCB IP */
#define XPAR_SCCB_IP_BASEADDR 0x8E000000
#define XPAR_SCCB_IP_HIGHADDR 0x8E0007FF

#define XPAR_SCCB_IP_CTR_REG  (XPAR_SCCB_IP_BASEADDR + 0x00)
#define XPAR_SCCB_IP_DEV_ADDR (XPAR_SCCB_IP_BASEADDR + 0x04)
#define XPAR_SCCB_IP_REG_ADDR (XPAR_SCCB_IP_BASEADDR + 0x08)
#define XPAR_SCCB_IP_DATA_WR  (XPAR_SCCB_IP_BASEADDR + 0x0C)
#define XPAR_SCCB_IP_DATA_RD  (XPAR_SCCB_IP_BASEADDR + 0x10)
#define XPAR_SCCB_IP_RESET    (XPAR_SCCB_IP_BASEADDR + 0x103)

#define XIic_WriteReg(BaseAddress, RegOffset, RegisterValue) \
	XIo_Out8((BaseAddress) + (RegOffset), (RegisterValue))

/* I/F functions declaration          */
//u8 sccb_dev_addr;
void sccb_reset(u8 dev_addr);
void sccb_write_reg(u8 reg_addr, u8 data);
u8   sccb_read_reg (u8 reg_addr);

#endif /* SCCB_H_ */
