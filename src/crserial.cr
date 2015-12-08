ifdef linux
    require "./crserial/libc"
    require "./crserial/posix_serial"
elsif windows
    # Doesn't work yet
end