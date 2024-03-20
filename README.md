<H1>Mount and unmount external file system on Linuxdeploy</H1>
I bought a Motorola g32 with a 1 tera sd card with Android 13.<BR>
My idea was to have a really powerful Linux computer fully integrated with Android.
But it is much more difficult to achieve than I thought, so I would like to share my work with everyone who is interested in doing the same thing.

<H3>1. Install Linuxdeploy</H3>

I chose the <CODE>Directory</CODE> <CODE>Installation type</CODE> to use my 1 tera sd card formatted in ext4, specifying as <CODE>Installation path</CODE> a subdirectory of Linuxdeploy <I>(/data/data/ru.meefik.linuxdeploy/root)</I> so that I could reinstall Linuxdeploy without losing the sd card data or I could create several profiles sharing the same /home directory
