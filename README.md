<H1>Mount external file system on Linuxdeploy</H1>
I bought a Motorola g32 with a 1 tera sd card.<BR>
My idea was to have a really powerful Linux computer fully integrated with Android 13. But it is much more difficult to achieve than I thought, so I would like to share my work with everyone who is interested in doing the same thing. 

<H3>1. Install Linuxdeploy</H3>

On the Properties profile I chose the <CODE>Installation type</CODE> <CODE>Directory</CODE> to use my 1 tera sd card formatted in ext4, specifying as <CODE>Installation path</CODE> a subdirectory of Linuxdeploy (<I>/data/data/ru.meefik.linuxdeploy/\<my-directory\></I>) so that I could reinstall Linuxdeploy without losing the sd card data or I could create several profiles sharing the same /home directory.<BR>
I also enable custom scripts with <CODE>Init system</CODE> <CODE>sysv</CODE>.

<H3>2. Mount file system</H3>

In the Properties profile, it is possible to specify a list of mount points in which to specify blocks-devices, directories or files outside of chroot that will be mounted in its namespace when Linuxdeploy start.<BR>
This is very limited because the mount points are not visible outside Linuxdeploy and it is not possible to mount Linuxdeploy directories or files on Android. Furthermore, in Android 13, system partitions are locked in <I>read-only</I> mode and it is therefore not possible to run scripts to mount anything.<BR>
I then wrote a bash script to mount everything I need.<BR>
The script run on Linuxdeploy outside its <I>chroot</I> thanks to <I>unchroot</I> command and mount block-devices, directories and files, specified in the <I>extfstab</I> file, in the global mount namespace thanks to <I>su</I> with the <I>--mount-master</I> option.

<H4>Edit extfstab</H4>

In the <I>extfstab</I> file there is a configuration like example.<BR>
The file is <I>fstab</I> like with four parameter: source, target-directory, mount-option and unmount-option.<BR>
If a parameter contain space, it must escaped with \ .<BR>
The environment variables $USER_NAME and $TARGET_PATH are initialized with the values of the <CODE>User</CODE> and <CODE>Installation path</CODE> parameters specified in the Properties profile.<BR>
The <I>mount</I> commands are executed in the same order as specified in the file, while <I>umount</I> commands are executed in the reverse order.

<H4>Install extfs</H4>
<UL>
<LI>Copy <I>extfs.sh</I> in /data/data/ru.meefik.linuxdeploy/bin directory.</LI>
<LI>Copy inside Linuxdeploy <I>extf</I> in /etc/init.d and <I>extfstab</I> in /etc directories.</LI>
<LI>Make sure the owner and the group of the files is <I>root</I> and the two script have execution permission.</LI>
<LI>Type the command: <CODE>su - -c 'update-rc.d extfs defaults'</CODE> for install <I>extfs</I> System-V init script, so that <I>extfs.sh</I> will be executed when Linuxdeploy is loaded.</LI>
</UL>

<H3>3. Share files with Android</H3>

In Android every app like a user are the owner of his files and shares them with other apps via the <I>everybody</I> group, then in Linuxdeploy you have to add the <I>user</I> to the <I>aid_everybody</I> group with the command: <CODE>su -c 'usermod -a -G aid_everybody \<user\>'</CODE> and set the <I>aid_everybody</I> group on the existing files and directories you want to share with the correct permissions.<BR>
To make sure that new files are created by Linuxdeploy with the group <I>aid_everybody</I> you must set the <I>Sticky Bit</I> on the directories you want to share with the command: <CODE>chmod g+s \<directory\></CODE>, also to grant to the group read/write permissions you need to add the <I>umask 006</I> entry in the <I>/etc/profile</I> file.<BR>
