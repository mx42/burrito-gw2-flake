test attempt on creatin derivation on nix to provide wrapped burrito overlay for the guild wars 2

for now it is a simple starting point in making derivations to provide packages on nix

I'll probably never get it to the end, because the person who pushed me to try this, dropped nixos, so, I don't have a tester.

But I want to get it to the point, where I can run `burrito.x86_64` without getting `not found *.so` errors.

```sh
ldd ./burrito.x86_64
>	linux-vdso.so.1 (0x00007ffd3315b000)
>	libc.so.6 => /nix/store/5adwdl39g3k9a2j0qadvirnliv4r7pwd-glibc-2.39-52/lib/libc.so.6 (0x00007effafd83000)
>	/lib64/ld-linux-x86-64.so.2 => /nix/store/5adwdl39g3k9a2j0qadvirnliv4r7pwd-glibc-2.39-52/lib64/ld-linux-x86-64.so.2 (0x00007effaff7c000)
>	libXcursor.so.1 => not found
>	libXinerama.so.1 => not found
>	libXext.so.6 => not found
>	libXrandr.so.2 => not found
>	libXrender.so.1 => not found
>	libX11.so.6 => not found
>	libXi.so.6 => not found
>	libGL.so.1 => not found
>	libpthread.so.0 => /nix/store/5adwdl39g3k9a2j0qadvirnliv4r7pwd-glibc-2.39-52/lib/libpthread.so.0 (0x00007effafd7c000)
>	libdl.so.2 => /nix/store/5adwdl39g3k9a2j0qadvirnliv4r7pwd-glibc-2.39-52/lib/libdl.so.2 (0x00007effafd75000)
>	libm.so.6 => /nix/store/5adwdl39g3k9a2j0qadvirnliv4r7pwd-glibc-2.39-52/lib/libm.so.6 (0x00007effafc8f000)
```

to solve this, as I understand it, I need to use `makeWrapper` in `nativeBuildInputs`, and then provide all packages in `pkgs.lib.makeBinPath (with pkgs; [ xorg.libX11 ])`

burrito repo is now working on automated github workflows to create a CI system, so I can have a sneak peek at the build process when they will finish it, because now I can't find any clues from the repo inself. I don't know how godot projects works in this regard.
