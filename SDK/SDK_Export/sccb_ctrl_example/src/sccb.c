/*
 * sccb.c
 *
 *  Created on: Nov 10, 2018
 *      Author: deokhwan
 */
#include "sccb.h"

/* I/F function implementation        */
void sccb_reset(u8 dev_addr) {
	//sccb_dev_addr = dev_addr;
	XIo_Out8(XPAR_SCCB_IP_RESET   , 0x0A);
	XIo_Out8(XPAR_SCCB_IP_DEV_ADDR, dev_addr);
	return;
}

void sccb_write_reg(u8 reg_addr, u8 data)
{
	int i;
	XIo_Out8(XPAR_SCCB_IP_REG_ADDR, reg_addr);
	XIo_Out8(XPAR_SCCB_IP_DATA_WR , data    );
	XIo_Out8(XPAR_SCCB_IP_CTR_REG , 0x80    );	// write+start trigger
	while( (XIo_In8(XPAR_SCCB_IP_CTR_REG) & 0x80) == 0x80 );
		for(i = 0; i < 100; i++)
			__asm__ ("nop");

	return;
}

u8 sccb_read_reg(u8 reg_addr)
{
	int i;
	u8 read_data;
	XIo_Out8(XPAR_SCCB_IP_REG_ADDR, reg_addr);
	XIo_Out8(XPAR_SCCB_IP_CTR_REG , 0xC0    );	// read+start trigger

	while( (XIo_In8(XPAR_SCCB_IP_CTR_REG) & 0x80) == 0x80 );
		for(i = 0; i < 100; i++)
			__asm__ ("nop");
	read_data = XIo_In8(XPAR_SCCB_IP_DATA_RD );

	return read_data;
}
