#include<stdint.h>
#define peripheral_clock_enable *((volatile uint32_t *)0x40021018)
#define port_configuration_reg *((volatile uint32_t *)0x40011004)
#define port_bit_reg *((volatile uint32_t *)0x40011010)
int main(){

	peripheral_clock_enable |=(1u<<4);

	port_configuration_reg&=~(0xf<<20);
	port_configuration_reg|=(0x2<<20);

	while(1){
		port_bit_reg=(1u<<13);

	volatile uint32_t counter=0;
	while(counter<100000){
		counter++;
	}
	port_bit_reg=(1u<<29);
	counter=0;
	while(counter<100000){
		counter++;
	}
	}
	return 0;

}