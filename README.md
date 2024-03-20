<H1>Mount and unmount external file system on Linuxdeploy</H1>
I bought a Motorola g32 with a 1 tera sd card with Android 13.<BR>
My idea was to have a really powerful Linux computer fully integrated with Android.
But it is much more difficult to achieve than I thought, so I would like to share my work with everyone who is interested in doing the same thing.

<H3>1. Install Linuxdeploy</H3>

On the Properties profile I chose the <CODE>Directory</CODE> <CODE>Installation type</CODE> to use my 1 tera sd card formatted in ext4, specifying as <CODE>Installation path</CODE> a subdirectory of Linuxdeploy (<I>/data/data/ru.meefik.linuxdeploy/root</I>) so that I could reinstall Linuxdeploy without losing the sd card data or I could create several profiles sharing the same /home directory

<H3>2. Mount file system</H3>

In the Properties profile, it is possible to specify a list of mount points in which to specify blocks-devices, directories or files outside of chroot that will be mounted in its namespace when Linuxdeploy start.<BR>
This is very limited because the mount points are not visible outside Linuxdeploy and it is not possible to mount Linuxdeploy directories or files on Android.
Furthermore, in Android 13, system partitions are locked in <I>ro</I> and it is therefore not possible to write scripts to mount anything.<BR>
I then wrote a bash script (<I>extfs.sh</I>) to mount everything I need.<BR>
The script runs on Linuxdeploy outside its <I>chroot</I> thanks to  <I>unchroot</I> command and mounts block-devices, directories and files, specified in the <I>extfstab</I> file in the global mount namespace thanks to <I>su</I> with the <I>--mount-master</I> option.
