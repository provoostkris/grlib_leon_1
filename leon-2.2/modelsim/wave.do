onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /tbleon/tb/p0/leon0/resetn
add wave -noupdate -format Logic /tbleon/tb/p0/leon0/clk
add wave -noupdate -format Logic /tbleon/tb/p0/leon0/errorn
add wave -noupdate -format Literal -radix hexadecimal /tbleon/tb/p0/leon0/address
add wave -noupdate -format Literal -radix hexadecimal /tbleon/tb/p0/leon0/data
add wave -noupdate -format Literal /tbleon/tb/p0/leon0/ramsn
add wave -noupdate -format Literal /tbleon/tb/p0/leon0/ramoen
add wave -noupdate -format Literal /tbleon/tb/p0/leon0/rwen
add wave -noupdate -format Literal /tbleon/tb/p0/leon0/romsn
add wave -noupdate -format Logic /tbleon/tb/p0/leon0/iosn
add wave -noupdate -format Logic /tbleon/tb/p0/leon0/oen
add wave -noupdate -format Logic /tbleon/tb/p0/leon0/read
add wave -noupdate -format Logic /tbleon/tb/p0/leon0/writen
add wave -noupdate -format Logic /tbleon/tb/p0/leon0/brdyn
add wave -noupdate -format Logic /tbleon/tb/p0/leon0/bexcn
add wave -noupdate -format Literal /tbleon/tb/p0/leon0/pio
add wave -noupdate -format Literal -radix hexadecimal /tbleon/tb/p0/leon0/mcore0/memi
add wave -noupdate -format Literal -radix hexadecimal /tbleon/tb/p0/leon0/mcore0/memo
add wave -noupdate -format Literal -radix hexadecimal /tbleon/tb/p0/leon0/mcore0/ioi
add wave -noupdate -format Literal -radix hexadecimal /tbleon/tb/p0/leon0/mcore0/ioo
add wave -noupdate -format Literal -radix hexadecimal /tbleon/tb/p0/leon0/mcore0/apbi
add wave -noupdate -format Literal -radix hexadecimal /tbleon/tb/p0/leon0/mcore0/apbo
add wave -noupdate -format Literal -radix hexadecimal -expand /tbleon/tb/p0/leon0/mcore0/ahbmi
add wave -noupdate -format Literal -radix hexadecimal -expand /tbleon/tb/p0/leon0/mcore0/ahbmo
add wave -noupdate -format Literal -radix hexadecimal /tbleon/tb/p0/leon0/mcore0/ahb0/r
add wave -noupdate -format Literal -radix hexadecimal /tbleon/tb/p0/leon0/mcore0/ahbsi
add wave -noupdate -format Literal -radix hexadecimal /tbleon/tb/p0/leon0/mcore0/ahbso
add wave -noupdate -format Literal -radix hexadecimal /tbleon/tb/p0/leon0/mcore0/proc0/ici
add wave -noupdate -format Literal -radix hexadecimal /tbleon/tb/p0/leon0/mcore0/proc0/ico
add wave -noupdate -format Literal -radix hexadecimal /tbleon/tb/p0/leon0/mcore0/proc0/dci
add wave -noupdate -format Literal -radix hexadecimal /tbleon/tb/p0/leon0/mcore0/proc0/dco
add wave -noupdate -format Literal /tbleon/tb/p0/leon0/mcore0/proc0/c0/icache0/r
add wave -noupdate -format Literal /tbleon/tb/p0/leon0/mcore0/proc0/c0/dcache0/r
add wave -noupdate -format Literal -radix hexadecimal /tbleon/tb/p0/leon0/mcore0/proc0/mcii
add wave -noupdate -format Literal -radix hexadecimal /tbleon/tb/p0/leon0/mcore0/proc0/mcio
add wave -noupdate -format Literal -radix hexadecimal /tbleon/tb/p0/leon0/mcore0/proc0/mcdi
add wave -noupdate -format Literal -radix hexadecimal /tbleon/tb/p0/leon0/mcore0/proc0/mcdo
add wave -noupdate -format Literal /tbleon/tb/p0/leon0/mcore0/proc0/a0/r
add wave -noupdate -format Literal -radix hexadecimal /tbleon/tb/p0/leon0/mcore0/mctrl0/r
add wave -noupdate -format Literal /tbleon/tb/p0/leon0/mcore0/proc0/iu0/fecomb
add wave -noupdate -format Literal -radix hexadecimal /tbleon/tb/p0/leon0/mcore0/proc0/iu0/fe
add wave -noupdate -format Literal -radix hexadecimal /tbleon/tb/p0/leon0/mcore0/proc0/iu0/de
add wave -noupdate -format Literal -radix hexadecimal /tbleon/tb/p0/leon0/mcore0/proc0/iu0/ex
add wave -noupdate -format Literal -radix hexadecimal /tbleon/tb/p0/leon0/mcore0/proc0/iu0/me
add wave -noupdate -format Literal -radix hexadecimal /tbleon/tb/p0/leon0/mcore0/proc0/iu0/wr
add wave -noupdate -format Literal -radix hexadecimal /tbleon/tb/p0/leon0/mcore0/proc0/iu0/sregs
add wave -noupdate -format Literal -radix hexadecimal /tbleon/tb/p0/leon0/mcore0/proc0/iu0/fpu_reg
add wave -noupdate -format Literal -radix hexadecimal /tbleon/tb/p0/leon0/mcore0/uart1/r
add wave -noupdate -format Literal -radix hexadecimal /tbleon/tb/p0/leon0/mcore0/uart2/r
add wave -noupdate -format Literal -radix hexadecimal /tbleon/tb/p0/leon0/mcore0/irqctrl0/ir
add wave -noupdate -format Literal -radix hexadecimal /tbleon/tb/p0/leon0/mcore0/ioport0/r
add wave -noupdate -format Literal -radix hexadecimal /tbleon/tb/p0/leon0/mcore0/timers0/r
add wave -noupdate -format Literal -radix hexadecimal /tbleon/tb/p0/leon0/mcore0/uart1/apbi
add wave -noupdate -format Literal -radix hexadecimal /tbleon/tb/p0/leon0/mcore0/uart1/apbo
add wave -noupdate -format Literal -radix hexadecimal /tbleon/tb/p0/leon0/mcore0/uart2/apbi
add wave -noupdate -format Literal -radix hexadecimal /tbleon/tb/p0/leon0/mcore0/uart2/apbo
add wave -noupdate -format Literal -radix hexadecimal /tbleon/tb/p0/leon0/mcore0/apb0/r
add wave -noupdate -format Literal -radix hexadecimal /tbleon/tb/p0/leon0/mcore0/mctrl0/promdata
add wave -noupdate -format Literal -radix hexadecimal /tbleon/tb/p0/leon0/mcore0/proc0/rfi
add wave -noupdate -format Literal -radix hexadecimal /tbleon/tb/p0/leon0/mcore0/proc0/rfo
add wave -noupdate -format Literal -radix hexadecimal /tbleon/tb/p0/leon0/mcore0/proc0/c0/crami
add wave -noupdate -format Literal -radix hexadecimal /tbleon/tb/p0/leon0/mcore0/proc0/c0/cramo
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {4720 ns}
WaveRestoreZoom {4651 ns} {4854 ns}
