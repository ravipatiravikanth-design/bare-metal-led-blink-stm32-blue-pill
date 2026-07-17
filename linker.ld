/************************************************************************
 * Entry Point
 *
 * Specifies the first function executed after a system reset.
 * The Cortex-M3 begins execution from Reset_handler.
 ***********************************************************************/

ENTRY(Reset_handler);


/************************************************************************
 * Memory Layout
 *
 * Defines the physical memory available on the STM32F103CBT6.
 *
 * FLASH : Stores the firmware and read-only data.
 * SRAM  : Stores variables during program execution.
 ***********************************************************************/

MEMORY
{
	FLASH(rx) : ORIGIN = 0x08000000, LENGTH = 128K

	SRAM(rwx) : ORIGIN = 0x20000000, LENGTH = 20K
}


/************************************************************************
 * Section Placement
 *
 * Defines how different sections of the program are arranged
 * in memory to generate the final executable.
 ***********************************************************************/

SECTIONS
{

	/************************************************************************
	 * .text Section
	 *
	 * Contains the interrupt vector table, executable instructions
	 * and read-only data.
	 *
	 * Since these contents never change during execution,
	 * they are placed in Flash memory.
	 ***********************************************************************/

	.text :
	{
		/* Interrupt Vector Table */
		*(.isr_vector)

		/* Executable Program Instructions */
		*(.text)

		/* Read-only Data */
		*(.rodata)

		/* Align the next section on a 4-byte boundary. */
		. = ALIGN(4);

		/* Marks the end of the .text section. */
		_etext = .;
	} > FLASH


	/************************************************************************
	 * .data Section
	 *
	 * Contains initialized global and static variables.
	 *
	 * The initial values are stored in Flash and copied into
	 * SRAM by the Reset Handler before main() is executed.
	 ***********************************************************************/

	.data :
	{
		/* Start of the .data section. */
		_sdata = .;

		*(.data)

		/* Align the next section on a 4-byte boundary. */
		. = ALIGN(4);

		/* End of the .data section. */
		_edata = .;
	} > SRAM AT > FLASH


	/************************************************************************
	 * .bss Section
	 *
	 * Contains uninitialized global and static variables.
	 *
	 * This section occupies SRAM only and is cleared by the
	 * Reset Handler before the application starts executing.
	 ***********************************************************************/

	.bss :
	{
		/* Start of the .bss section. */
		_sbss = .;

		*(.bss)

		/* Align the next section on a 4-byte boundary. */
		. = ALIGN(4);

		/* End of the .bss section. */
		_ebss = .;
	} > SRAM
}
	