#!perl -w
BEGIN {
print "DBIx::Web CMDB application installer/updater\n";
}
use DBI;

my $root =input('Database manager',    'root');
my $rpsw =input('Manager\'s password', '');
my $cgbd =input('Database name',       'cgibus');
my $cgbu =input('Database user',       'cgibus');
my $cgbp =input('User\'s password',    '********');

print "Connecting to 'DBI:mysql:mysql' as '$root'...\n";
my $mysql=DBI->connect("DBI:mysql:mysql",$root,$rpsw)
        ||die("Couls not connect to mysql as '$root'");
my $db   =$mysql;

print "Executing <DATA>, some SQL DML error messages may be ignored...\n\n";
my $row;
my $cmd ='';
my $cmt ='';
while ($row =<DATA>) {
  chomp($row);
  if ($cmd && ($row =~/^#/ || ($cmd !~/^\s*\{/ && $cmd =~/;\s*$/) )) {
     my $v;
     chomp($cmd);
     print $cmt ||$cmd, " -> ";
     if   ($cmd =~/^\s*\{/) {$v =eval($cmd);   print $@ ? $@ : 'ok'}
     else {$v =$db->do($cmd); print $db->err ? $db->errstr : 'ok'}
     print ': ', defined($v) ? $v : 'null', "\n\n";
     $cmd ='';
     $cmt ='';
  }
  next if $row =~/^\s*#*\s*$/;
  if    ($row =~/^#/ && $cmd !~/^\s*\{/) {
        $cmt =$row;
  }
  elsif ($row =~/^\s*#/ || $row eq '') {
  }
  else {
        $cmd .=($cmd ? "\n" : '') .$row;
  }  
}


sub input {
 my ($pr, $dv) =@_;
 print $pr, @_ >1 ? ' [' .(defined($dv) ? $dv : 'null') .']' :'', ': ';
 my $r =<STDIN>;
 chomp($r);
 $r eq '' ? $dv : $r
}

#
##########################################
# DATABASE DEFINITIONS & UPDATES
##########################################
#
__END__
#
#
CREATE DATABASE IF NOT EXISTS cgibus;
#
#
{$db->do("GRANT ALL PRIVILEGES ON ${cgbd}.* TO ${cgbu}\@localhost IDENTIFIED BY '${cgbp}' WITH GRANT OPTION;")}
#
#
{$db=undef; $db =DBI->connect("DBI:mysql:$cgbd",$cgbu,$cgbp); <STDIN>}
#
#
# CMDBM PDM
 #========================
 # '-' - reserved fields
#
#
{"'cmdbm' table"
 ###########################
}
#
create table cmdbm (
	id	varchar(60) primary key,
	idnv	varchar(60),	# new version (value) pointer
	cuser	varchar(60),	# creator user
	ctime	datetime,	# created time
	uuser	varchar(60),	# updator user
	utime	datetime,	# updated time

	authors	varchar(60),	# actor role
	readers	varchar(60),	# reader role
	status	varchar(10),	# record status

	record  	varchar(20),	# record type
	name		varchar(80),	# record name
	definition	varchar(255),

	system		varchar(80),	# 
	service		varchar(80),	# 
	application	varchar(80),	# 

	type		varchar(80),	# 
	model		varchar(80),	# 
	invno		varchar(40),
	location	varchar(80),
	cpu		varchar(40),
	ram		decimal,
	hdd		decimal,
	hardware	varchar(80),
	os		varchar(80),

	action		varchar(80),	# 
	computer	varchar(80),	# 
	slot		varchar(80),	# 
	device		varchar(80),	# 
	port		varchar(80),	# 
	ipaddr		varchar(20),
	ipmask		varchar(20),
	macaddr		varchar(40),
	speed		varchar(10),
	duplex		varchar(10),

	interface	varchar(80),	# 

	ugroup		varchar(80),	# 
	role		varchar(80),	# 
	user		varchar(80),	# 
	userdef		varchar(255),	#
	office		varchar(80),	# 

	description	varchar(80),	# 

	comment		text		#   comment, text
)	# TYPE = BDB	# using mysqld-max
;
#
#
#
{"'cmdbm' indexes"
 ###########################
}
#
 DROP   INDEX name     ON cmdbm;
 CREATE INDEX name     ON cmdbm (name, idnv);
 DROP   INDEX idnv     ON cmdbm;
 CREATE INDEX idnv     ON cmdbm (idnv,    utime);
#
#
#
{"'hdesk' table"
 ###########################
}
# 
CREATE TABLE hdesk (
	id	varchar(60) NOT NULL	default '',
	idnv	varchar(60)	default NULL,
	idpr	varchar(60)	default NULL,
	idrm	varchar(60)	default NULL,
	idrr	varchar(60)	default NULL,
	idpt	varchar(60)	default NULL,
	idlr	varchar(60)	default NULL,
	lslote	varchar(60)	default NULL,
	cuser	varchar(60)	default NULL,
	ctime	datetime	default NULL,
	uuser	varchar(60)	default NULL,
	utime	datetime	default NULL,
	puser	varchar(60)	default NULL,
	prole	varchar(60)	default NULL,
	auser	varchar(60)	default NULL,
	arole	varchar(60)	default NULL,
	aopt	varchar(10)	default NULL,
	rrole	varchar(60)	default NULL,
	mailto	varchar(255)	default NULL,
	mailtime	datetime	default NULL,
	status	varchar(10)	default NULL,
	severity	decimal(1,0)	default NULL,
	progress	decimal(10,0)	default NULL,
	etime	datetime	default NULL,
	stime	datetime	default NULL,
	period	varchar(20)	default NULL,
	record	varchar(10)	default NULL,
	object	varchar(60)	default NULL,
	application	varchar(80)	default NULL,
	location	varchar(80)	default NULL,
	process	varchar(80)	default NULL,
	cost	decimal(10,2)	default NULL,
	doctype	varchar(60)	default NULL,
	subject	varchar(255)	default NULL,
	comment	text,
	PRIMARY KEY  (id),
	KEY idnv	(idnv,etime,utime),
	KEY idpr	(idpr,etime,utime),
	KEY idrm	(idrm,etime,utime),
	KEY idrr	(idrr,etime,utime),
	KEY record	(record,etime,utime),
	KEY object	(object,etime,utime),
	KEY doctype	(doctype,etime,utime),
	KEY auser	(auser,etime,utime),
	KEY arole	(arole,etime,utime),
	KEY application	(application,etime,utime),
	KEY location	(location,etime,utime),
	KEY process	(process,etime,utime)
);
#
#
#
{"2006-12-22 'cmdbm' add fields"
 ###########################
}
# 
ALTER TABLE cmdbm ADD COLUMN idold varchar(60) AFTER id;
ALTER TABLE cmdbm ADD COLUMN stmt varchar(80) AFTER definition;
ALTER TABLE cmdbm ADD COLUMN vtime datetime AFTER utime;
#
#
#
