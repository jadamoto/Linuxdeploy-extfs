<H2>Mount and unmount external file system on Linuxdeploy</H2>
I bought a Motorola g32 with a 1 tera sd card with Android 13.<BR>e
But it is much more difficult to achieve than I thought, so I would like to share my work with everyone who is interested in doing the same thing.

<H3>1. Install Linuxdeploy</H3>

On the Properties profile I chose the <CODE>Installation type</CODE> <CODE>Directory</CODE> to use my 1 tera sd card formatted in ext4, specifying as <CODE>Installation path</CODE> a subdirectory of Linuxdeploy (<I>/data/data/ru.meefik.linuxdeploy/<my-directory></I>) so that I could reinstall Linuxdeploy without losing the sd card data or I could create several profiles sharing the same /home directory.<BR>
I also enable custom scripts with <CODE>Init system</CODE> <CODE>sysv</CODE>

<H3>2. Mount file system</H3>

In the Properties profile, it is possible to specify a list of mount points in which to specify blocks-devices, directories or files outside of chroot that will be mounted in its namespace when Linuxdeploy start.<BR>
This is very limited because the mount points mount everything I need.<BR>
The script runs on Linuxdeploy outside its <I>chroot</I> thanks to  <I>unchroot</I> command and mount block-devices, directories and files, specified in the <I>extfstab</I> file, in the global mount namespace thanks to <I>su</I> with the <I>--mount-master</I> option.

<H4>Edit extfstab</H4>
In the <I>extfstab</I> file there is my personal configuration like example.<BR>
The file is <I>fstab</I> like with four parameter: SOURCE, TARGET, MOUNT_OPT and UMOUNT_OPT.<BR>
If a parameter contain space, it must escaped with \.<BR>
The environment variables $USER_NAME and $TARGET_PATH are initialized with the values specified in the <CODE>User</CODE> and <CODE>Installation path</CODE> parameters typed in the Properties profile.

<H4>Install extfs</H4>
Copy <I>extfs.sh</I> in /data/data/ru.meefik.linuxdeploy/bin directory.<BR>
Copy inside Linuxdeploy <I>extf</I> in /etc/init.d and <I>extfstab</I> in /etc<BR>
Make sure the owner and the group of the files is <I>root</I> and the two script have execution permission.<BR>
Type the command: <CODE>su - -c 'update-rc.d extfs defaults'</CODE> for install <I>extfs</I> System-V init script.<BR>

