#!perl -w
#
# DBIx::Web - Active Web Database Layer
#
# makarow@mail.com, started 2003-09-16
#
# Future ToDo:
# - test sql data engine
# - message translation into russian
# - review '!!!'
# - ui: changes display, but what differ and how in html?
# - 'recRead' alike calls may return an objects, knows metadata
#
# Problems - Think:
#
#
# ToDo:
# - test application, think
#
# Done:
#
# 2004-06-26 review '!!!' (categorization, primary todos implementation)
# 2004-06-23 default query conditions display
# 2004-06-23 temporary files environment variables redesigned
# 2004-06-22 using 'DHTML Editing Component'
# 2004-06-21 'dbmSeek' string condition parser improved
# 2004-06-21 XML record lists
# 2004-06-19 XML record form
# 2004-06-18 menu listboxes behaviour improved
# 2004-06-13 log file more readable
#		+ input / operation / rezult	- operation only
#		+ '-name'=>value forms
#		+ quoting and terminating SQL
# 2004-06-11 full-text search in file attachments
# 2004-06-08 corrected 'nfopens', 'nfclose', 'w32domain'
# 2004-06-06 'ddvIndex'; 'logRec' analisys
# 2004-06-01 ui: html styles - using classes
# 2004-05-15 '-urole' & '-uname' query keywords
# 2004-03-16 paused
# 2004-03-12 table factory triggers and documentation
# 2004-03-03 ui: printable html
# 2004-02-29 'mdeTable', 'mdlTable': table factory base
# 2004-02-27 not needed: restrict 'recIns' and 'recUpd' values to described '-field's?
# 2004-02-27 '-keyord' & '-filter': query conditions unification: order option, key, joint, filter codeblock, while codeblock
# 2004-02-26 'ns' naming set
# 2004-02-22 default indexes (versions, news, references,...) review
# 2004-02-17 table/ID rec IDs in 'History' view
# 2004-02-17 embedded versions view definition
# 2004-02-08 'setup' sub, '-setup' & '-reindex' command line options.
# 2004-02-06 drop file sessions to attachments: 'nfopens', 'nfclose', 'htmlRFD'
# 2004-02-03 problem documented: optimizing dbm cursor looping in 'rec'/'dbi' code
# 2004-02-02 necessary: duplicate fields&valies copying in 'recXXX' for triggers and in 'dbiXXX' for SQL or cleanup special fields for dbi
# 2004-02-01 optional html convertors of fields 'cgiList'ed - 'lsthtml'
# 2004-01-29 documentation spell and check
# 2004-01-26 document size analisys
# 2004-01-25 document concepts
# 2004-01-11 'cgiParse':  '-key' split into table/form and rec ID, if needed
# 2004-01-10 'recNew' all field values inheritance problem: -recNew0R trigger should inherit
# 2004-01-09 dbm -key search interpretation, -order options metastructure
# 2004-01-09 dbm -where search condition interpretation
# 2004-01-06 indexing trigger '-recIndex0R'
# 2004-01-04 record form is alike table in 'recType' and 'rmiTrigger'.
# 2004-01-04 reformed '-joint' idea to '-recJoint1R' trigger and '-qfilter' sub{}
# 2004-01-03 file attachments database API
# 2003-12-28 CGI user interface initial implementation
# 2003-12-28 perl script pages implemented
# 2003-12-27 documentation started
# 2003-12-25 record ID splitting problem: $RISM[012], -idsplit, -recInsID, -rfdName
# 2003-12-21 user authentication
# 2003-12-21 message constants
# 2003-12-18 user group file usage; also generation in windows
# 2003-12-15 'w32IISdpsn' to escape IIS impersonation
# 2003-12-14 acls (see '!!!' about 'LIKE')
# 2003-12-14 attachments acls
# 2003-12-07 '-joint' codeblock problem resolved by incapsulated hash ref binding
# 2003-12-07 incapsulated hash ref binding
# 2003-11-19 implement '-affect' db interface
# 2003-11-18 generate alphanumeric incremental record IDs instead long numeric
# 2003-11-17 cgiDDLB
# 2003-11-10 form vs table problem - 'recRead' loads record only, not join, '-read' option like '-query'
# 2003-11-09 sql full-text search
# 2003-11-09 consider old versions in 'dbiUpd'
# 2003-11-08 version display switching for 'recSel'/'dbiSel'/'cgiXXX'
# 2003-11-07 cgi file attachments
# 2003-11-02 commit/rollback/finish
# 2003-10-11 first cgi script for testing
# 2003-10-07 begin of smallest database API testing
# 2003-09-16 started
#


package DBIx::Web;
require 5.000;
use strict;
use UNIVERSAL;
use POSIX;
use Fcntl qw(:DEFAULT :flock :seek :mode);

use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS $AUTOLOAD $SELF $CACHE $LNG $IMG);

	$VERSION= '0.53';
	$SELF   =undef;				# current object pointer
	$CACHE	={};				# cache for pointers to subobjects
	*isa    = \&UNIVERSAL::isa; isa('','');	# isa function

my	$RISM0  ='/';		# record identification separation mark 0
my	$RISM1	='//';		# record identification table/id seperator 
				# (-idsplit; consider -recInsID, -rfdName)
my	$RISM2  ='.rfd';	# record identification end   special mark 
my	$NLEN	=14;		# length to pad left numbers in indexes
my	$LIMRS	=512;		# limit of result set
my	$KSORD	='-aall';	# default key sequental order
my	$HS	=';';		# hyperlink parameters separation style '&'


	# see also '-ns' definitions

if	($ENV{MOD_PERL}) { # $ENV{GATEWAY_INTERFACE} && $ENV{GATEWAY_INTERFACE} =~/^CGI-Perl\//
	eval('use Apache qw(exit);');
}

$LNG ={
''	=>{''		=>['',		'']
	,-lang		=>['en',	'']
	,-charset	=>['windows-1252','']

	,-affected	=>['affected',	'rows affected']
	,-fetched	=>['fetched',	'rows fetched']
	,'rfaUplEmpty'	=>['empty',	'Empty filehandle']
	,'recUpdAclStp'	=>['',		'Record updation prohibited to you']
	,'recUpdVerStp'	=>['',		'Editing record\'s version prohibited']
	,'recDelAclStp'	=>['',		'Record deletion prohibited to you']
	,'recReadAclStp'=>['',		'Record reading prohibited to you']

	,'back'		=>['<',		'Back screen']
	,'login'	=>['Login',	'Register as personated user']
	,'frmCall'	=>['Go',	'Goto/execute choise']
	,'frmName'	=>['Form',	'Form name to choose']
	,'recNew'	=>['New',	'Create new record to insert into database']
	,'recRead'	=>['Read',	'Read record from the database']
	,'recEdit'	=>['Edit',	'Edit this data to update in the database']
	,'recPrint'	=>['Print',	'Printable form']
	,'recXML'	=>['XML',	'XML form']
	,'recIns'	=>['Insert',	'Insert this data into database']
	,'recUpd'	=>['Save',	'Update this record or save data into database']
	,'recDel'	=>['Delete',	'Delete this record in the database']
	,'recForm'	=>['Form',	'Recheck this data on server']
	,'recList'	=>['List',	'List records, execute query']
	,'recQBF'	=>['Query',	'Specify records to be listed']
	,'submit'	=>['Submit',	'Submit this form to be executed by the server']
	,'Create'	=>['Create']
	,'Close'	=>['Close']

	#'-key'		=>
	#'-where'	=>
	#'-orderby'	=>
	,'-qwhere'	=>['WHERE',	'WHERE query clause']
	,'-qurole'	=>['UROLE',	'Role of User']
	,'-quname'	=>['UNAME',	'Name of User']
	,'-qftext'	=>['FULL TEXT',	'Full-text search string']
	,'-qversion'	=>['VERSIONS',	'Including old versions of records']
	,'-qorder'	=>['ORDER BY',	'ORDER BY query clause']
	,'-qlimit'	=>['LIMIT',	'LIMIT query clause']

	,'Attachments'	=>['Attachments','File Attachments']
	,'Upload'	=>['Upload',	'File to upload']
	,'+|-'		=>['+/ -',	'Upload file, delete attachments selected']
	,'rfaopen'	=>['...',	'Opened file attachments to be closed']
	,'rfadelm'	=>['Delete',	'Mark file attachments to be deleted']

	,'ddlbopen'	=>['...',	'Open values']
	,'ddlbsubmit'	=>['Set',	'Assign value selected']
	,'ddlbclose'	=>['x',		'Close values']
	,'ddlbfind'	=>['..',	'Find value in the list']

	,'ddoRVC'	=>['RVC',	'Record Version Control']
	,'ddvRVV'	=>['Versions',	'Record Versions View']
	,'ddvRHV'	=>['History',	'Updates History View']
	,'ddvRRV'	=>['References','Record References View']
	,'ddvIndex'	=>['Index',	'Index page']
	,'ddvFTQuery'	=>['Query text','Full-text query on files']
	,'qftCall'	=>['Search',	'Full-text search on files']
	,'-qftwhere'	=>['Query',	'Full-text query condition']

	,'table'	=>['Table',	'Table or recfile name']
	,'id'		=>['ID',	'Record ID', 'id']
	,'ir'		=>['IR',	"Refered ID"]
	,'idrm'		=>['AboveID',	"Record, above this, 'id' or 'table'//'id'"]
	,'idpr'		=>['PrevID',	"Record, previous to this, 'id' or 'table'//'id'"]
	,'cuser'	=>['Ins by',	'User, record inserted by']
	,'ctime'	=>['Ins time',	'Date and time, record inserted when']
	,'uuser'	=>['Upd by',	'User, record updated by']
	,'utime'	=>['Upd time',	'Date and time, record updated when']
	,'idnv'		=>['Ver of',	'Actual record ID']
	,'status'	=>['State',	'State of the record']
	,'auser'	=>['Actor',	'Actor of the record, user name']
	,'arole'	=>['Actors',	'Role(s) of actor of the record or additional actors']
	,'puser'	=>['Principal',	'Principal of record, user name']
	,'prole'	=>['Principals','Principals of record, users and groups']
	,'authors'	=>['Authors',	'Authors of the record, comma delimited']
	,'readers'	=>['Readers',	'Readers of the record, comma delimited']
	,'record'	=>['Record',	'Class/type of the record described by']
	,'object'	=>['Object',	'Object of the record described by']
	,'project'	=>['Project',	'Project, related to the record']
	,'subject'	=>['Subject',	'Subject, Title, Brief description']
	,'comment'	=>['Comment',	"Comment text or HTML, 'urlh://', 'urlr://', 'urlf://' URL protocols may be used to denote relative URLs to host, this script, file store"]
	,'cargo'	=>['Cargo',	'Additional data']
	}
,'ru'	=>{''		=>['',		'']
	,-lang		=>['ru-RU',	'']
	,-charset	=>['windows-1251','']
	,'frmCall'	=>['���.',	'��������� �������, ��������, �����']
	}
};


$IMG={
	 'back'		=>'back.gif'
	,'login'	=>'small/key.gif'
	,'frmCall'	=>'hand.up.gif' # hand.up continued left transfer folder.open
	,'recNew'	=>'generic.gif'
	,'recRead'	=>'up.gif'
	,'recEdit'	=>'quill.gif'
	,'recPrint'	=>'p.gif'
	,'recXML'	=>'script.gif'
	,'recIns'	=>'burst.gif'
	,'recUpd'	=>'down.gif'
	,'recDel'	=>'broken.gif'
	,'recForm'	=>'forward.gif'
	,'recList'	=>'text.gif'
	,'recQBF'	=>'index.gif'
	,'Attachments'	=>'folder.open.gif'
};

1;



#######################


sub new {
 my $c=shift;
 my $s ={};
 bless $s,$c;
 $s =$s->initialize(@_);
}



sub initialize {
 my $s   =shift;
 my %opt =@_;
 $CACHE->{$s} ={};
 %$s =(
    -title	=>''		# Application's title
  #,-locale	=>''		# Application's locale
  #,-lang	=>undef		# Application's language
  #,-charset	=>undef		# Application's charset
  #,-lng	=>undef		# User's language

   ,-debug      =>0		# Debug Mode
   ,-die        =>\&CORE::die	# die  / croak / confess: &{$s->{-die} }('error')
   ,-warn       =>\&CORE::warn	# warn / carp  / cluck  : &{$s->{-warn}}('warning')

 # ,-var        =>undef		# Variables {}, see varLoad, varStore
   ,-log        =>1		# Log file switch/handle, see logOpen
   ,-logm	=>100		# Log list max size

   ,-c => {			# Cache for computed values
        # ,-pth_tmp	=>undef	# Temporary files path, see pthForm('tmp')
        # ,-pth_var	=>undef	# Variable  files path, see pthForm('var')
        # ,-pth_log	=>undef	# Log       files path, see pthForm('log')
	# ,-logm	=>[]	# Log list
        # ,-user	=>undef	# User Name
        # ,-unames	=>[]	# User Names
        # ,-ugroups	=>[]	# User Groups
          }

 # ,-path       =>'./dbix-web'	# Path to file store, default below
 # ,-url        =>'/dbix-web'	# URL  to file store, default below
 # ,-urf        =>'file://./dbix-web'# Filesystem URL to file store, default below
                  

   ,-host	=>undef		# Host  Name, default below
 # ,-dbi	=>undef		# DBI object, if used
 # ,-dbiarg	=>undef		# DBI connection arguments string or array
 # ,-cgi	=>undef		# CGI object
   ,-serial	=>1		# Serialised: 1 - updates, 2 - updates & reads, 3 - reads
 # ,-output	=>undef		# output sub{} instead of 'print'

   ,-table	=>{}		# database files
				# -field=>{name=>{}}
				# -key	=>[field]
				# -keycmp=>sub{}	# key compare dbm sub{}
				# -ixcnd=>sub{}||1	# index condition
				# -ixrec=>sub{}		# form index record
				# -optrec		# optional records
				# -dbd =>'dbi'|'dbm'	# database store
				# -recXXX		# trigger or implementation

				# -subst		# substitute another
				# -cgcXXX=>''|sub{}	# cgi call implementation
				# -cgvXXX=>''|sub{}	# cgi call presentation

				# -query		# query condition hash
				# -qfilter		# filters rows fetched
				# -qhref		# query hyperlink hash or sub{}
				# -qhrcol		# q h left columns
				# -qflghtml		# !empty flag when '!h'
				# -qfetch		# query fetch sub{}
				# -limit		# query limit rows

				# -recRead		# recRead condition hash

 # ,-user	=>undef		# User Name   sub{} or value, default below
 # ,-unames	=>[]		# User Names  sub{} or value
 # ,-ugroups	=>[]		# User Groups sub{} or value
 # ,-AuthUserFile		# Apache Users  file, optional
 # ,-AuthGroupFile		# Apache Groups file, optional
 # ,-fswtr	=>undef		# File Store Writers, default below
 # ,-fsrdr	=>undef		# File Store Readers

 # ,&recXXX			# DML command keywords
					# -table -forn || record form class
					# -from
					# -data
					# -key -where 
					# -urole -uname
					# -filter -limit
					# -order -keyord -group
					# -save -optrec -test
					# -new -file # record attributes

				# Record Manipulation Options:
 # ,-dbd	=>undef		# default database engine
   ,-autocommit =>1		# autocommit database mode
 # ,-limit	=>undef||number	# limit of selection
 # ,-affect	=>undef||1	# rows number to affect by DML
 # ,-affected			# rows number affected	by DML
 # ,-fetched			# rows number fetched	by DBL
 # ,-limited			# rows number limited	by DBL
 # ,-index	=>boolean	# include materialized views support
   ,-idsplit	=>1 		# split complex rec ID to table and row ID: 0 || sub{}

				# Record Access Control rooles:
   ,-rac	=>1		# switch on
   ,-racAdmin	=>'Administrators,root'
 # ,-racReader	=>[fieldnames]	# readers fieldnames
 # ,-racWriter	=>[fieldnames]	# writers fieldnames

				# Record Version Control rooles:
 # ,-rvcInsBy	=>'fieldname'	# field for user name	record inserted	by
 # ,-rvcInsWhen	=>'fieldname'	# field for time	record inserted	when
 # ,-rvcUpdBy	=>'fieldname'	# field for user name	record updated	by
 # ,-rvcUpdWhen	=>'fieldname'	# field for time	record updated	when
 # ,-rvcActPtr	=>'fieldname'	# field for actual record version pointer
 # ,-rvcFinState=>[fld=>states]	# final	    states of record
 # ,-rvcCkoState=>[fld=>state ]	# check-out state  of record
 # ,-rvcDelState=>[fld=>state ]	# deleted   state  of record

				# Record File Attachments rooles:
   ,-rfa	=>1		# switch on
 # ,-rfdName	=>sub{}		# 'rfdName'  formula for key processing

                                # Record ID References
 # ,-ridRef	=>[]		# reference fields

				# Record Manipulation Triggers:
 # ,-recNew	=>'form'|sub{}	# 'recNew'  UI implementation
 # ,-recNew0R	=>sub{}		# 'recNew'  trigger before	each row
 # ,-recNew1C	=>sub{}		# 'recNew'  trigger after	command
 # ,-recForm	=>'form'|sub{}	# 'recForm' UI implementation
 # ,-recForm1R	=>sub{}		# 'recForm' trigger after	each row
 # ,-recForm1C	=>sub{}		# 'recForm' trigger after	command
 # ,-recIns	=>'form'|sub{}	# 'recIns'  UI implementation
 # ,-recIns0C	=>sub{}		# 'recIns'  trigger before	command
 # ,-recIns0R	=>sub{}		# 'recIns'  trigger before	each row
 # ,-recInsID	=>sub{}		# 'recIns'  trigger for key generation
 # ,-recIns1R	=>sub{}		# 'recIns'  trigger after	each row
 # ,-recIns1C	=>sub{}		# 'recIns'  trigger after	command
 # ,-recUpd	=>'form'|sub{}	# 'recUpd'  UI implementation
 # ,-recUpd0C	=>sub{}		# 'recUpd'  trigger before	command
 # ,-recUpd0R	=>sub{}		# 'recUpd'  trigger before	each row
 # ,-recUpd1C	=>sub{}		# 'recUpd'  trigger after	command
 # ,-recDel	=>'form'|sub{}	# 'recDel'  UI implementation
 # ,-recDel0C	=>sub{}		# 'recDel'  trigger before	command
 # ,-recDel0R	=>sub{}		# 'recDel'  trigger before	each row
 # ,-recDel1C	=>sub{}		# 'recDel'  trigger after	command
 # ,-recSel0C	=>sub{}		# 'recSel'  trigger before	command
 # ,-recRead	=>'form'|sub{}	# 'recRead' UI implementation
 # ,-recRead0C	=>sub{}		# 'recRead' trigger before	command
 # ,-recRead0R	=>sub{}		# 'recRead' trigger before	each row
 # ,-recRead1R	=>sub{}		# 'recRead' trigger after	each row
 # ,-recRead1C	=>sub{}		# 'recRead' trigger after	command
 # ,-recList	=>'form'|sub{}	# 'recList' UI implementation

   ,-ns		=>{             # Default naming set, see also 'ns' sub
	 ''		=>''
	,-guest		=>'guest'	# guest user name
	,-quests	=>'guests'	# guest user group
	,-users		=>'users'	# authenticated user default group
	,-dbd		=>'dbm'		# defaultest data engine

	,-id		=>'id'		# record identifier
	,-key		=>['id']	# record key
	,-rvcInsBy	=>'cuser'	# user, record inserted by
	,-rvcInsWhen	=>'ctime'	# time, record inserted when
	,-rvcUpdBy	=>'uuser'	# user, record updated  by
	,-rvcUpdWhen	=>'utime'	# time, record updated  when
			# 'auser'	# actor user
			# 'arole'	# actor roles
			# 'puser'	# principal user
			# 'prole'	# principal roles
	,-rvcActPtr	=>'idnv'	# id of new version of record
			# 'idrm'	# id of master record
			# 'idrr'	# id of root reference
			# 'idpr'	# id of previous record in cause chain
			# 'idpt'	# point to record
			# 'idlr'	# location record pointer
	,-rvcState	=>'status'	# state of record
	,-rvcAllState	=>['ok','no','do','progress','chk-out','edit','deleted']
	,-rvcFinState	=>['status'=>'ok','no','deleted']
	,-rvcCkoState	=>['status'=>'chk-out']
	,-rvcDelState	=>['status'=>'deleted']
   }
				# CGI server user interface
 # ,-httpheader =>{}
 # ,-htmlstart  =>{}
   ,-icons	=>'/icons'	# Icons URL
 # ,-logo	=>''		# Logotype to display
   ,-login	=>'/cgi-bin/ntlm/'# Login URL
 # ,-menuchs	=>[[]]
 # ,-menuchs1	=>[[]]
 # ,-form	=>{}		# user interface forms, see '-table'
 # ,-pcmd	=>{}		# command input parameters
 # ,-pdta	=>{}		# data input
 # ,-pout	=>{}		# parameters output (cursor)
   );
 $s->set(@_);
 if (!$s->{-path}) {
	my $pth =$^O eq 'MSWin32' ? Win32::GetFullPathName($0) : $0;
	$pth =  $ENV{DOCUMENT_ROOT}
		? $ENV{DOCUMENT_ROOT} .'/'
		: $pth =~/^(.+?[\\\/]wwwroot[\\\/])/i
		? $1
		: $pth =~/^(.+?[\\\/]inetpub[\\\/])/i
		? $1
	 	: $pth =~/^(.+?[\\\/])cgi-bin[\\\/]/i && -d ($1 .'htdocs')
		? $1 .'htdocs/'
		: $pth =~/^(.+?[\\\/]apache[\\\/])/i && -d ($1 .'htdocs')
		? $1 .'htdocs/'
		: $pth =~/^(.+[\\\/])[^\\\/]*$/
		? $1
		: -d '../htdocs'
		? '../htdocs/'
		: -d '../wwwroot'
		? '../wwwroot/'
		: './';
	$s->set(-path=>$pth .'dbix-web');
 }
 $s->set(-url=>'/dbix-web')
	if !$s->{-url};
 $s->set(-urf=>'file://' .$s->{-path})
	if !$s->{-urf};
 $s->set(-locale=>POSIX::setlocale(&POSIX::LC_CTYPE()))
	if !$s->{-locale};
 $s->set(-die=>($ENV{GATEWAY_INTERFACE}||'') =~/CGI/ ? 'CGI::Carp qw(fatalsToBrowser warningsToBrowser)' : 'Carp')
	if !$opt{-die};
 $s->set(-host=>
	($ENV{COMPUTERNAME}||$ENV{HOSTNAME}||eval('use Sys::Hostname;hostname')||'localhost') 
	=~/^([\d.]+|[\w\d_]+)/ ? $1 : 'unknown'
	)
	if !$s->{-host};
 $s->set(-user=>sub{$ENV{REMOTE_USER}||$ENV{USERNAME}||$s->{-ns}->{-guest}})
	if !$s->{-user};
 $s->set(-fswtr=>$ENV{USERNAME} || $^O eq 'MSWin32' ? eval{Win32::LoginName} : `logname`) 
	&& (chomp($s->{-fswtr})||1)
	&& ($s->{-fswtr} =[$s->{-fswtr}])
	if !$s->{-fswtr};
 $s->set(-recInsID=>sub{
		$_[0]->varLock();
		$_[2]->{'id'} =lc($_[0]->{-host})
		.strpad($_[0],$_[0]->{-var}->{-table}->{$_[1]->{-table}}->{-recInsID}
		=dwnext($_[0],$_[0]->{-var}->{-table}->{$_[1]->{-table}}->{-recInsID}));
		$_[0]->varStore();
		$_[2]->{'id'}})
	if !$s->{-recInsID};
 if ($ENV{MOD_PERL}) {
    Apache->push_handlers("PerlCleanupHandler"
           ,sub{eval{$s->end}; eval('Apache::DECLINED;')});
 }
 $ENV{TMP} =$ENV{TEMP} =$ENV{TMP}||$ENV{tmp}||$ENV{TEMP}||$ENV{temp}
			||$ENV{TMPDIR}		# see CGI.pm source
			||$s->pthForm('tmp');
 $s
}


sub class {
 substr($_[0], 0, index($_[0],'='))
}


sub set {
 return(keys(%{$_[0]})) if scalar(@_) ==1;
 return($_[0]->{$_[1]}) if scalar(@_) ==2;
 my ($s, %opt) =@_;
 foreach my $k (keys(%opt)) {
	$s->{$k} =$opt{$k};
 }
 if ($opt{-die}) {
	my $s =$_[0];
	if    (ref($opt{-die})) {}
	elsif ($opt{-die} =~/^(perl|core)$/i) {
		$s->{-warn} =\&CORE::warn; $s->{-die} =\&CORE::die;
	}
	elsif ($opt{-die}) {
		$s->{-warn} =eval('use ' .$s->{-die} .($s->{-debug} ?'; \\&cluck'   :'; \\&carp' ));
		$s->{-die}  =eval('use ' .$s->{-die} .($s->{-debug} ?'; \\&confess' :'; \\&croak'));
	}
	$SIG{__DIE__}	=sub{return if $^S; eval{$s->logRec('Die', ($_[0] =~/(.+)[\n\r]+$/ ? $1 : $_[0]))}; eval{$s->recRollback()}};
	$SIG{__WARN__}	=sub{return if $^S; eval{$s->logRec('Warn',($_[0] =~/(.+)[\n\r]+$/ ? $1 : $_[0]))}};
 }
 if ($opt{-locale}) {
	$s->{-lng}	='';
	$s->{-lang}	=lc($opt{-locale} =~/^(\w\w)/	? $1	: 'en');
	$s->{-charset}	=$opt{-locale} =~/\.(.+)$/	? $1	: '1252';
 }
 if ($opt{-autocommit}) {
	$s->{-dbi}->{AutoCommit} =$opt{-autocommit} if $s->{-dbi};
 }
 $s
}


sub lng {
 $_[0]->{-lng} =$LNG->{defined($_[0]->{-lng}) ? lc($_[0]->{-lng}) : ''} 
	||	$LNG->{''}
	if !ref($_[0]->{-lng});
  @_ <3 
? ($_[0]->{-lng}->{$_[1]}->[0] ||$LNG->{''}->{$_[1]}->[0] ||$_[0]->{-lng}->{$_[1]}->[1] ||$LNG->{''}->{$_[1]}->[1] || $_[1])
: @_ <4
? ($_[0]->{-lng}->{$_[2]}->[$_[1]] ||$LNG->{''}->{$_[2]}->[$_[1]] ||$_[2])
: eval {my $r =lng(@_[0..2]); 
	my $v =!ref($_[3]) ? $_[3] : ref($_[3]) eq 'CODE' ? &{$_[3]}(@_) : strdata($_[0], $_[3]);
	   $v ='undef' if !defined($v);
	$r =~s/\$_/$v/ge ? $r : "$r $v"
	}
}


sub die {
 &{$_[0]->{-die}}(@_[1..$#_])
}


sub warn {
 &{$_[0]->{-warn}}(@_[1..$#_])
}


sub start {	# start session
 my $s =shift;
 my %o =@_;
 $CACHE->{$s}	={};
 $s->{-c}	={};
 $s->{-var}->{'_handle'}->destroy if $s->{-var} && $s->{-var}->{'_handle'};
 $s->{-fetched} =0;
 $s->{-limited} =0;
 $s->{-affected}=0;
 $s->w32IISdpsn() if (($ENV{SERVER_SOFTWARE}||'') =~/IIS/) && $ENV{REMOTE_USER}
			&& $s->cgi->param('_qftwhere');
 $s->varLoad($s->{-serial} >2 ? LOCK_EX : $s->{-serial} >1 ? LOCK_SH : 0);
 $s->logOpen if $s->{-log} && !ref($s->{-log});
 $s->{-log}->lock(0) if ref($s->{-log});
 $s->set(@_);
 $s
}


sub end {	# end session
 my $s =shift;
 $s->recCommit() if $s->{-dbi};
 $s->{-var}->{'_handle'}->destroy if $s->{-var} && $s->{-var}->{'_handle'};
 $s->{-log}->lock(0) if ref($s->{-log});
 $s->{-log}->destroy if ref($s->{-log});
 $s->{-log}	=undef;
 $s->{-c}	={};
 $CACHE->{$s}	={};
 delete $s->{-cgi};
 $s
}


sub setup {	# Setup script execution
 my ($s) =@_;

 print "Writing sample '.htaccess-$VERSION' file...\n";
 my $pth =$s->pthForm('tmp') && $s->{-path};
    $pth =~s/\\/\//g;
 $s->hfNew('+>', ($pth .'/.htaccess-' .$VERSION))->lock(LOCK_EX)
	->store( "# Default data and pulic directory tree configuration.\n"
		."# Should be included in 'httpd.conf'.\n"
		."# Include " .($pth .'/.htaccess-' .$VERSION) ."\n"
		."\n"
		."#<IfModule !mod_ntlm.c>\n"
		."#\tLoadModule ntlm_module modules/mod_ntlm.so\n"
		."#</IfModule>\n"
		."#<IfModule !mod_auth_sspi.c>\n"
		."#\tLoadModule sspi_auth_module modules/mod_auth_sspi.so\n"
		."#</IfModule>\n"
		."<Directory " .$pth ." >\n"
		."#\tAllowOverride All\n"
		."\tAllowOverride Limit AuthConfig\n"
		."\tOptions -FollowSymLinks\n"
		."\tAccessFileName .htaccess\n"
		."\tOrder Allow,Deny\n"
		."\tAllow from All\n"
		."#\t<IfModule mod_ntlm.c>\n"
		."#\t\tAuthType NTLM\n"
		."#\t\tNTLMAuth On\n"
		."#\t\tNTLMAuthoritative On\n"
		."#\t\tNTLMOfferBasic On\n"
		."#\t</IfModule>\n"
		."#\t<IfModule mod_auth_sspi.c>\n"
		."#\t\tAuthType SSPI\n"
		."#\t\tSSPIAuth On\n"
		."#\t\tSSPIAuthoritative On\n"
		."#\t\tSSPIOfferBasic On\n"
		."#\t</IfModule>\n"
		.($s->{-AuthUserFile}
		?"\tAuthUserFile " .$s->{-AuthUserFile} ."\n"
		:"#\tAuthUserFile ???\n")
		."\tAuthGroupFile " .($s->{-AuthGroupFile} ||($pth ."/var/authgroup")) ."\n"
		."</Directory>\n")
	->destroy;
 $s->pthForm('rfa');

 print "Executing <DATA>, some SQL DML error messages may be ignored...\n\n";
 local $s->{-dbiargpv}	=$s->{-dbiarg};
 local $s->{-affect}	=undef;
 local $s->{-rac}	=undef;
 my $row;
 my $cmd ='';
 my $cmt ='';
 while ($row =<main::DATA>) { $row =<main::DATA> if 0;
	chomp($row);
	if ($cmd && ($row =~/^#/)) {
		my $v;
		chomp($cmd);
		print $cmt ||$cmd, " -> ";
		local $SELF	=$s;
		local $_	=$s;
		if   ($cmd =~/^\s*\{/) {
			$v =eval($cmd);
			print $@ ? $@ : 'ok'
		}
		else {
			$v =$s->dbi->do($cmd);
			print $s->dbi->err ? $s->dbi->errstr : 'ok'
		}
		print ': ', defined($v) ? $v : 'undef', "\n\n";
		$cmd ='';
		$cmt ='';
	}
	if	($row =~/^\s*#*\s*$/ || $row =~/^\s+#/ || $row eq '') {
		next
	}
	elsif	($row =~/^#/) {
		$cmt =$row
	}
	else {
		$cmd .=($cmd ? "\n" : '') .$row
	}
 }
 $s
}


#########################################################
# Misc Data methods
#########################################################


sub dwnext {	# next digit-word string value
		# self, string, ? min length
 my $v =$_[1] ||'0';
 for(my $i =1; $i <=length($v); $i++) {
	next if ord(substr($v,-$i,1)) >=ord('z');
	substr($v,-$i,1)=chr(ord(substr($v,-$i,1) eq '9' ? chr(ord('a')-1) : substr($v,-$i,1)) +1);
	substr($v,-$i+1)='0' x ($i-1) if $i >1;
	return($_[2] && length($v) <$_[2] ? '0' x ($_[2] -length($v)) .$v : $v)
 }
 $v =chr(ord('0')+1) .('0' x length($v));
 $_[2] && length($v) <$_[2] ? '0' x ($_[2] -length($v)) .$v : $v
}


sub grep1 {	# first non-empty value
		# self, list
		# self, sub{}, list
 local $_;
 if (ref($_[1]) ne 'CODE') {
	foreach (@_[1..$#_]) {return($_) if $_}
 }
 else {
	my $t;
	foreach (@_[2..$#_]) {$t =&{$_[1]}(); return $t if $t}
 }
 return(())
}


sub max {	# maximal number
 (($_[1]||0) >($_[2]||0) ? $_[1] : $_[2])||0
}


sub min {	# minimal number
 (($_[1]||0) >($_[2]||0) ? $_[2] : $_[1])||0
}


sub orarg {	# argument of true result
 shift(@_);
 my $s =ref($_[0]) ? shift 
       :index($_[0], '-') ==0 ? eval('sub{' .shift(@_) .' $_}')
       :eval('sub{' .shift(@_) .'($_)}');
 local $_;
 foreach (@_) {return $_ if &$s($_)};
 undef
}


sub strpad {	# string padding
		# self, string, ?pad char, ?min length
 length($_[1]) <$NLEN ? ($_[2]||'0') x ($_[3] ||$NLEN -length($_[1])) .$_[1] : $_[1];
}


sub strdata {	# Stringify any data structure
  my $v =$_[1];
 !defined($v) 
 ? ''
 : !ref($v)
 ? $v # ($v =~s/([\x00-\x1f\\])/sprintf("\\x%02x",ord($1))/eg ? $v : $v)
 : isa($v, 'ARRAY')
 ? join(', ', map {my $v =$_;
	  ref($v)
	? ('(' .strdata($_[0],$v) .')')
	: !defined($v)
	? ''
	: $v =~s/([\x00-\x1f,;=\\\)\(])/sprintf("\\x%02x",ord($1))/eg
	? $v
	: $v
	} @$v)
 : isa($v, 'HASH')
 ? join(', ', map {my ($k, $v) =($_, $_[1]->{$_});
	$k =~s/([\x00-\x1f,;=\\\)\(])/sprintf("\\x%02x",ord($1))/eg;
	  ref($v)
	? ($k .'=(' .strdata($_[0],$v) .')')
	: !defined($v)
	? ''
	: $v =~s/([\x00-\x1f,;=\\\)\(])/sprintf("\\x%02x",ord($1))/eg
	? "$k=$v"
	: "$k=$v"
	} sort keys %$v)
 : $v
}


sub strdatah {	# Stringify hash data structure
 return(strdata(@_)) if $#_ <2;
 my $r ='';
 for (my $i =1; $i <$#_; $i +=2) {
	my ($k, $v) =@_[$i, $i+1];
	$k	=~s/([\x00-\x1f,;=\\\)\(])/sprintf("\\x%02x",ord($1))/eg;
	$r	.=$k .'='
		.(!defined($v)
		? ''
		: ref($v)
		? strdata($_[0], $v)
		: $v =~s/([\x00-\x1f,;=\\\)\(])/sprintf("\\x%02x",ord($1))/eg
		? $v
		: $v)
		.','
 }
 chop($r);
 $r
}


sub strquot {	# Quote and Escape string
 my $v =$_[1];
 return('undef') if !defined($v);
 $v =~s/([\\'])/\\$1/g;
 $v =~s/([\x00-\x1f])/sprintf("\\x%02x",ord($1))/eg;
 $v =~/^\d+$/ ? $v : ('\'' .$v .'\'');
}



sub datastr {	# Data structure from String
		# (for data structure strings only!)
 my $v =$_[1];
    $v =~/[=]/
 ? {grep {defined($_)} map { /^\(/
	? datastr($_[0], substr($_,1,-1)) ||undef
	: s/\\x([0-9a-fA-F]{2})/chr hex($1)/eg
	? $_
	: $_
	} split / *[,;=] */, $v}
 : $v =~/[,;]/
 ? [grep {defined($_)} map { /^\(/
	? datastr($_[0], substr($_,1,-1)) ||undef
	: s/\\x([0-9a-fA-F]{2})/chr hex($1)/eg
	? $_
	: $_
	} split / *[,;=] */, $v]
 : $v =~s/\\x([0-9a-fA-F]{2})/chr hex($1)/eg
 ? $v
 : $v
}

sub dsdClone {	# Clone data structure
   !ref($_[1]) ? $_[1]
 : ref($_[1]) eq 'ARRAY' ? [map {ref($_) ? dsdClone($_[0], $_) : $_} @{$_[1]}]
 : ref($_[1]) eq 'HASH'  ? {map {($_, dsdClone($_[0], $_[1]->{$_}))} keys %{$_[1]}}
 : $_[1]
}


sub dsdMk {     # Data structure dump to string
 my ($s, $d) =@_;
 eval('use Data::Dumper');
 my $o =Data::Dumper->new([$d]); 
 $o->Indent(1);
 $o->Dump();
}


sub dsdParse {  # Data structure dump string to perl structure
 my ($s, $d) =@_;
 eval('use Safe');
 Safe->new()->reval($d)
}


sub strtime {	# Stringify Time
 my $s =shift;
 my $msk =@_ ==0 || $_[0] =~/^\d+$/i ? 'yyyy-mm-dd hh:mm:ss' : shift;
 my @tme =@_ ==0 ? localtime(time) : @_ ==1 ? localtime($_[0]) : @_;
 $msk =~s/yyyy/%Y/;
 $msk =~s/yy/%y/;
 $msk =~s/mm/%m/;
 $msk =~s/mm/%M/i;
 $msk =~s/dd/%d/;
 $msk =~s/hh/%H/;
 $msk =~s/hh/%h/i;
 $msk =~s/ss/%S/;
#eval('use POSIX');
 POSIX::strftime($msk, @tme)
}


sub timestr {	# Time from String
 my $s   =shift;
 my $msk =@_ <2 || !$_[1] ? 'yyyy-mm-dd hh:mm:ss' : shift;
 my $ts  =shift;
 my %th;
 while ($msk =~/(yyyy|yy|mm|dd|hh|MM|ss)/) {
    my $m=$1; $msk =$';
    last if !($ts =~/(\d+)/);
    my $d =$1; $ts   =$';
    $d   -=1900   if $m eq 'yyyy' ||$m eq '%Y';
    $m    =chop($m);
    $m    ='M'    if $m eq 'm' && $th{$m};
    $m    =lc($m) if $m ne 'M';
    $th{$m}=$d;
 }
#eval('use POSIX');
 POSIX::mktime($th{'s'}||0,$th{'M'}||0,$th{'h'}||0,$th{'d'}||0,($th{'m'}||1)-1,$th{'y'}||0)
}


sub timeadd {	# Adjust time to years, months, days,...
 my $s =shift;
 my @t =localtime(shift);
 my $i =5;
 foreach my $a (@_) {$t[$i] += ($a||0); $i--}
#eval('use POSIX');
 POSIX::mktime(@t[0..5])
}


sub cptran {	# Translate strings between codepages
 my ($s,$f,$t,@s) =@_; 
 foreach my $v ($f, $t) {
   if    ($v =~/oem|866/i)   {$v ='���������������������������������������񦧨�����������������������'}
   elsif ($v =~/ansi|1251/i) {$v ='�����Ũ����������������������������������������������������������'}
   elsif ($v =~/koi/i)       {$v ='�������������������������������������ţ��������������������������'}
   elsif ($v =~/8859-5/i)    {$v ='������������������������������������������������������������������'}
 }
 map {eval("~tr/$f/$t/")} @s; 
 @s >1 ? @s : $s[0];
}


sub ishtml {	# Looks like HTML?
 ($_[1] ||'') =~m/^<(?:(?:B|BIG|BLOCKQUOTE|CENTER|CITE|CODE|DFN|EM|I|KBD|P|SAMP|SMALL|STRIKE|STRONG|STYLE|SUB|SUP|TT|U|VAR)\s*>|(?:BR|HR)\s*\/{0,1}>|(?:A|BASE|BASEFONT|DIR|DIV|DL|!DOCTYPE|FONT|H\d|HEAD|HTML|IMG|IFRAME|MAP|MENU|OL|PRE|TABLE|UL)\b)/i
}


sub htmlEscape {
 join '',
 map {	my $v =$_; return('') if !defined($_);
	$v =~s{&}{&amp;}gso;
	$v =~s{<}{&lt;}gso;
	$v =~s{>}{&gt;}gso;
	$v =~s{"}{&quot;}gso;
	$v
     } @_[1..$#_]
}


sub htmlUnescape {
 join '',
 map {	my $v =$_; return('') if !defined($_);
	$v =~s[&(.*?);]{
   	    local $_ = $1;
		/^amp$/i	? "&" :
		/^quot$/i	? '"' :
		/^gt$/i		? ">" :
		/^lt$/i		? "<" :
		$_;
	}gex;
	$v
 } @_[1..$#_]
}


sub urlEscape {
 join '',
 map {	my $v =$_; return('') if !defined($_);
	$v =~s/([^a-zA-Z0-9_.-])/uc sprintf("%%%02x",ord($1))/eg;
	$v
 } @_[1..$#_]
}


sub urlUnescape {
 join '',
 map {	local $_ =$_; return('') if !defined($_);
	tr/+/ /;
	s/%([0-9a-fA-F]{2})/chr hex($1)/ge;
 } @_[1..$#_]
}


sub urlCat {
 my $r =$_[1] .'?';
 for (my $i =2; $i <$#_; $i+=2) {$r .=urlEscape($_[0], $_[$i]) .'=' .urlEscape($_[0], $_[$i+1]) .$HS}
 chop($r);
 $r
}


sub xmlEscape {
 join '',
 map {	my $v =$_; return('') if !defined($v);
	$v =~s/([\\"<])/\\$1/g;
      # $v =~s/([^\w\d ,<.>\/?:;"'\[\]{}`~!@#$%^&*()-_=+\\|])/ ord($1) < 0x20 ? sprintf('\\x%02x',ord($1)) : $1/eg;
	$v =~s/([\x00-\x1F])/sprintf('\\x%02x',ord($1))/eg;
	$v
 } @_[1..$#_]
}


sub xmlAttrEscape {
 xmlEscape(@_)
}


sub xmlTagEscape {
 join '',
 map {	my $v =$_; return('') if !defined($v);
	$v =~s/([\\"<])/\\$1/g;
      # $v =~s/([^\w\d\s\n ,<.>\/?:;"'\[\]{}`~!@#$%^&*()-_=+\\|])/ ord($1) < 0x20 ? sprintf('\\x%02x',ord($1)) : $1/eg;
	$v =~s/([\x00-\x08\x0B-\x0C\x0E-\x1F])/sprintf('\\x%02x',ord($1))/eg;
		# \t=0x09; \n=0x0A; \r=0x0D;
	$v
 } @_[1..$#_]
}


sub xmlUnescape {
 join '',
 map {	my $v =$_; return('') if !defined($v);
	$v =~s/\\\\/\\/g;
	$v =~s|(\\+)([<"])| int(length($1)/2)*2 == length($1) ? ('\\' x (length($1)-1) .$2) : ($1 .$2)|ge;
	$v =~s|(\\+)(x\d+)| int(length($1)/2)*2 == length($1) ? ('\\' x (length($1)-1) .chr(hex($2))) : ($1 .$2)|ge;
	$v
 } @_[1..$#_]
}


sub lsTag {	# Attribute list to tag strings list 
 my($c, $v, $n);# htmlEscape, urlEscape, tagEscape, self, tagname, attr=>value,...
 $#_+1 !=2*int(($#_+1)/2)
 ? 0
 : substr($_[$#_],0,1) eq "\n"
 ? ($n =$_[$#_])
 : ($c =$_[$#_]);
 ((!ref($_[$[+4])
 ? ('<', $_[$[+4]
   ,(map  {$_[$_]
 	  ? (defined($_[$_+1]) 
	    ? (' ', substr($_[$_],0,1) eq '-' ? substr($_[$_],1) : $_[$_], '="'
	       , &{$_[$_] ne 'href' ? $_[$[] : $_[$[+1]}
	        ($_[$[+3], !ref($_[$_+1]) ? $_[$_+1] : strdata($_[$[+3], $_[$_+1]))
	      , '"') 
	    : ())
	  : eval{$c =$_[$_]; $v =$_[$_+1]; ()}
	  } map {$_*2+3} $[+1..int(($#_-3)/2) )
   ,(!defined($c)
     ? ' />'
     : $c eq '0'
     ? '>'
     :  ('>'
       ,  (ref($v) eq 'CODE') && ($v =&{$v}) && 0
	  ? ()
     	  : ref($v) eq 'ARRAY'
     	  ? &lsTag(@_[$[..$[+3], $v)
	  : defined($v)
	  ? &{$_[$[+2]}($_[$[+3], $v)
	  : ()
       , '</', $_[$[+4], '>') )
   )
 : ref($_[$[+4]) eq 'ARRAY'
 ? (map {ref($_) ne 'ARRAY' ? &{$_[$[+2]}($_[$[+3], $_) : lsTag(@_[$[..$[+3], @$_)} @{$_[$[+4]})
 : ref($_[$[+4]) eq 'HASH' && eval{$v =$_[$[+4]; $c =$v->{'-'}||$v->{'-tag'}||'tag'}
 ? ('<', $c
   ,(map {defined($v->{$_}) 
         ?(' '
	  , substr($_,0,1) eq '-' ? substr($_, 1) : $_, '="'
	  , &{$_ ne 'href' ? $_[$[] : $_[$[+1]}
	    ($_[$[+3], !ref($v->{$_}) ? $v->{$_} : strdata($_[$[+3], $v->{$_}))
          ,'"')
         :()
         } 
         sort grep {$_ && $_ !~/^-(tag|data|)$/} keys %$v)
   , (grep {exists($v->{$_}) && eval{$v =$v->{$_}}} '', '-data')
   ? ('>'
     ,(ref($v) eq 'CODE') && ($v =&{$v}) && 0
      ? ()
      : ref($v) eq 'ARRAY'
      ? &lsTag(@_[$[..$[+3], $v)
      : defined($v)
      ? &{$_[$[+2]}($_[$[+3], $v)
      : ()
     ,'</',$c,'>')
   : exists($v->{0})  
   ? '>'
   : ' />'
   )
 : ()
 ), !$n ? () : $n)
}


sub htlsTag {	# Attribute list to html strings list
 lsTag(\&htmlEscape, \&urlEscape, \&htmlEscape, @_)
}


sub xmlsTag {	# Attribute list to xml strings list
 lsTag(\&xmlAttrEscape, \&xmlAttrEscape, \&xmlTagEscape, @_)
}


#########################################################
# Misc Utility methods
#########################################################


sub cgi {       # CGI object
 return($_[0]->{-cgi}) if $_[0]->{-cgi};
 eval("use CGI; 1") || &{$_[0]->{-die}}("use CGI -> $@");
 $_[0]->{-cgi} =eval("CGI->new()")
	|| &{$_[0]->{-die}}("CGI::new() -> $@");
}


sub dbi {       # DBI connection object
 return ($_[0]->{-dbi}) if $_[0]->{-dbi};
 $_[0]->{-dbi} =eval("use DBI;")
		&& DBI->connect(ref($_[0]->{-dbiarg}) 
				? @{$_[0]->{-dbiarg}}
				: $_[0]->{-dbiarg})
		|| &{$_[0]->{-die}}($_[0]->lng(0,'dbi') .": DBI::conect() -> " .$DBI::errstr);
 $_[0]->{-dbi}->{AutoCommit} =$_[0]->{-autocommit};
 $_[0]->{-dbi}
}


sub hfNew {     # New file handle object
 local $SELF =$_[0];
 DBIx::Web::FileHandle->new(-parent=>$_[0]
	,@_ >2 ? (-mode=>$_[1], -name=>$_[2]) 
	:@_ >1 ? (-name=>$_[1])
	: ())
}


sub ccbNew {	# New condition code block object
 local $SELF =$_[0];
 DBIx::Web::ccbHandle->new($_[1])
}


sub dbmNew {	# New isam datafile object
 local $SELF =$_[0];
 DBIx::Web::dbmHandle->new(-parent=>$_[0], @_ >2 ? @_[1..$#_] : (-name=>$_[1]))
}


sub dbmTable {	# Get isam datafile object
 return(&{$_[0]->{-die}}('Bad table \'' .$_[1] .'\'')) if !$_[1];
   $CACHE->{$_[0]}->{'-dbm/' .$_[1]}
||($CACHE->{$_[0]}->{'-dbm/' .$_[1]}
	=$_[0]->dbmNew(	 -name	=>$_[0]->pthForm('dbm',$_[1])
			,-table	=>$_[0]->{-table}->{$_[1]}
			,-lock	=>LOCK_SH))->opent
}


sub osCmd {     # OS Command
                # -'i'gnore retcode
  my $s   =shift;
  my $opt =substr($_[0],0,1) eq '-' ? shift : ''; 
  my $sub =ref($_[$#_]) eq 'CODE' ? pop : undef;
  my $r;
  my $o;
  local(*RDRFH, *WTRFH);
  $s->logRec('osCmd', @_);
  if ($^O eq 'MSWin32' 	        # !!! arguments may need to be quoted
   || $^X =~/perlis\.dll$/i) {	# ISAPI, DB_File operation problem hacks
     if (!$sub) {
        my $c =join(' ', @_) .' 2>&1';
        @$o =`$c`
     }
     else {                     # !!! command's output will be lost
        open(WTRFH, '|-', join(' ', @_) .' >nul 2>&1') && defined(*WTRFH) 
        || return(&{$_[0]->{-die}}(join(' ',$s->lng(0,'osCmd'),@_) .' -> ' .$!)||0);
        my $ls =select(); select(WTRFH); $| =1;
        &$sub($s) if $sub;
        select($ls);
        eval{close(WTRFH)}
     }
  }
  else {
     eval('use IPC::Open2');
     my $pid = IPC::Open2::open2(\*RDRFH, \*WTRFH, @_); 
     if ($pid) {
        if ($sub) {
           my $select =select();
           select(WTRFH);
           $| =1;
           &$sub($s);
           select($select);
        }
        @$o =<RDRFH>;
        waitpid($pid,0);
     }
  }
  $r =$?>>8;
  return(&{$s->{-die}}(join(' ',$s->lng(0,'osCmd'),@_) .($opt !~/h/ ? '' : ' -> ' .join('',@{$o||[]})) ." -> $r")||0) 
       if $r && $opt !~/i/;
  if ($o) {foreach my $e (@$o) {
	$s->logRec('osCmd',$e)
  }}
  !$r ? $o ||[] : undef
}


sub nfopens {	# opened files (`net file`)
		# (mask, ?container)
 return(undef) if $^O ne 'MSWin32';
 my $rc =$_[2]||[];
 my $mask =$_[1]||''; $mask =~s/\//\\/ig;
#[map {chomp($_); $_} map {/^\d+\s+(.+)\s+\d+[\n\r\s]*$/ ? $1 : $_} grep /^\d+\s*\Q$mask\E/i, `net file`]
 my $o =eval('use Win32::OLE; Win32::OLE->GetObject("WinNT://'
	.(eval{Win32::NodeName()}||$ENV{COMPUTERNAME}) .'/lanmanserver")');
 return(undef) if !$o;
 if (ref($rc) eq 'HASH') {
	%$rc =map {(substr($_->{Path}, length($mask)+1), $_->{User} .': ' .substr($_->{Path}, length($mask)+1))
		} grep {(eval{$_->{Path}}||'') =~/^\Q$mask\E/i
			} Win32::OLE::in($o->Resources());
	# %$rc =(1=>'1.1',2=>'2.1',3=>'3.1');
	$rc =undef if !%$rc
 }
 else {
	@$rc =map {eval{substr($_->{Path}, length($mask)+1)}
		} grep {(eval{$_->{Path}}||'') =~/^\Q$mask\E/i  # $_->GetInfo;
			} Win32::OLE::in($o->Resources());
	$rc =undef if !@$rc
 }
 $rc
}


sub nfclose {	# close opened files (`net file /close`)
		# (mask, [filelist])
 return(0) if $^O ne 'MSWin32';
 my $mask =$_[1]||''; $mask =~s/\//\\/ig;
 my $list =$_[2]||[];
#foreach my $f (grep /^\d+\s*\Q$mask\E/i, `net file`) {
#	next if $f !~/^(\d+)\s*(.+)\s+\d+[\n\r\s]*$/i;
#	my ($h,$n) =($1,$2);
#	next if !grep /^\Q$n\E/i, @$list;
#	$_[0]->osCmd('net','file',$h,'/close');
#}
 my $o =eval('use Win32::OLE; Win32::OLE->GetObject("WinNT://'
	.(eval{Win32::NodeName()}||$ENV{COMPUTERNAME}) .'/lanmanserver")');
 return(0) if !$o;
 foreach my $f (grep {$_ && (eval{$_->{Path}}||'')=~/^\Q$mask\E/i
			} Win32::OLE::in($o->Resources())) {
	my $n =eval{$f->{Path} =~/^\Q$mask\E[\\\/]*(.+)/i ? $1 : undef};
	next if !$n || !grep /^\Q$n\E$/i, @$list;
	$_[0]->osCmd('net','file',$f->{Name},'/close');
 }
 1
}


sub output {    # Output to user, like print, but redefinable
  (!$_[0]->{-output} ? print @_[1..$#_] : &{$_[0]->{-output}}(@_)) 
 && $_[0]
}


sub outhtm  {	# Output HTML tag
  output($_[0], htlsTag(@_))
}

sub outhtml {	# Output HTML tag
  output($_[0], htlsTag(@_))
}


sub outxml  {	# Output XML tag
  output($_[0], xmlsTag(@_))
}


#########################################################
# Filesystem methods
#########################################################


sub pthForm {  # Form filesystem path for 'tmp'|'log'|'var'|'dbm'|'rfa'
 join('/', $_[0]->{-c}->{'-pth_' .$_[1]} ||pthForm_(@_), @_[2..$#_]);
}


sub pthForm_{
 my $p =($_[0]->{-c}->{'-pth_' .$_[1]} 
       =($_[1] eq 'tmp' && ($ENV{TMP} ||$ENV{tmp} ||$ENV{TEMP} ||$ENV{temp}))
       ||join('/', $_[0]->{-path}, $_[1]));
 if (!-d $p) {
	$_[0]->pthMk($p);
	$_[0]->hfNew('+>', "$p/.htaccess")->lock(LOCK_EX)
		->store("<Files * >\nOrder Deny,Allow\nDeny from All\n</Files>\n")
		->destroy
		if $_[1] ne 'rfa';
	if ($ENV{OS} && $ENV{OS}=~/Windows_NT/i && ($_[1] ne 'rfa')) {
		$p =~s/\//\\/g;
		$_[0]->osCmd('cacls', "\"$p\"", '/T','/C','/G'
		,(map{(m/([^@]+)\@([^@]+)/ ? "$2\\$1" : $_) .':F'
			} ref($_[0]->{-fswtr}) 
			? (@{$_[0]->{-fswtr}}) 
			: ($_[0]->{-fswtr}))
		,sub{CORE::print "Y\n"})
	}
 }
 $p
}


sub pthMk {    # Create directory if needed
  return(1) if -d $_[1];
  my $a ='';
  foreach my $e (split /\//, $_[1]) {
     $a .=$e;
     if (!-d $a) {
	$_[0]->logRec('mkdir', $a) if !$_[0]->{-log} ||ref($_[0]->{-log});
        mkdir($a, 0777) ||return(&{$_[0]->{-die}}($_[0]->lng(0,'pthMk') .": mkdir('$a') -> $!")||0);
     }
     $a .='/'
  }
  2;
}


sub pthGlob {  # Glob directory
  my $s =shift;
  my @ret;
  if    ($^O ne 'MSWin32') {
     CORE::glob(@_)
  }
  elsif (-e $_[0]) {
     push @ret, $_[0];
     @ret
  }
  else {
     my $msk =($_[0] =~/([^\/\\]+)$/i ? $1 : '');
     my $pth =substr($_[0],0,-length($msk));
     $msk =~s/\*\.\*/*/g;
     $msk =~s:(\(\)[].+^\-\${}[|]):\\$1:g;
     $msk =~s/\*/.*/g;
     $msk =~s/\?/.?/g;
     local (*DIR, $_); 
     opendir(DIR, $pth eq '' ? './' : $pth) 
           || return(&{$s->{-die}}($s->lng(0,'pthGlob') .": opendir('$pth') -> $!")||0);
     while(defined($_ =readdir(DIR))) {
       next if $_ eq '.' || $_ eq '..' || $_ !~/^$msk$/i;
       push @ret, "${pth}$_";
     }
     closedir(DIR) || return(&{$s->{-die}}($s->lng(0,'pthGlob') .": closedir('$pth') -> $!")||0);
     @ret
  }
}


sub pthGlobn { # Glob filenames only
 map {$_ =~/[\\\/]([^\\\/]+)$/ ? $1 : $_} shift->pthGlob(@_)
}


sub pthRm {    # Remove filesystem path
               # '-r' - recurse subdirectories, 'i'gnore errors
  my $s   =shift;
  my $opt =$_[0] =~/^\-/ || $_[0] eq '' ? shift : '';
  my $ret =1;
  $s->logRec('pthRm',$opt,@_);
  foreach my $par (@_) {
    foreach my $e ($s->pthGlob($par)) {
      if (-d $e) {
         if ($opt =~/r/i && !$s->pthRm($opt,"$e/*")) {
               $ret =0
         }
         elsif (!rmdir($e)) {
               $ret =0;
               $opt =~/i/i || return(&{$_[0]->{-die}}($s->lng(0, 'pthRm') .": rmdir('$e') -> $!")||0);
         }
      }
      elsif (-f $e && !unlink($e)) {
            $ret =0;
            $opt =~/i/i || return(&{$_[0]->{-die}}($s->lng(0, 'pthRm') .": unlink('$e') -> $!")||0);
      }
    }
  }
  $ret
}


sub pthCln {   # Clean unused (empty) directory
  return(0) if !-d $_[1];
  my ($s, $d) =@_;
  my @g =$s->pthGlob("$d/*");
  return(0) if scalar(@g) >1 
            || scalar(@g) ==1 && $g[0] !~/\.htaccess$/i;
  foreach my $f (@g) { unlink($f) };
  while ($d && rmdir($d)) { $d =($d =~m/^(.+)[\\\/][^\\\/]+$/ ? $1 : '') };
  !-d $d
}


sub pthCp {    # Copy filesystem path
               # -'d'irectory or 'f'ile hint; 'r'ecurse subdirectories, 'i'gnore errors
  my $s   =shift;
  my $opt =$_[0] =~/^-/i ? shift : '';
  my ($src,$dst) =@_;
  $opt =~s/-//g;
  if ($^O eq 'MSWin32' 
     && (eval{Win32::IsWinNT} ||(($ENV{OS}||'') =~/Windows_NT/i))) {
     $src =~tr/\//\\/;
     $opt ="${opt}Z";
     $opt ="${opt}Y" if ([eval{Win32::GetOSVersion()}]->[1] ||0) >=5
  }
  elsif ($^O eq 'MSWin32') {
     $src =~tr/\//\\/;
     $dst =~tr/\//\\/
  }
  if ($^O ne 'MSWin32' && $^O ne 'dos') {
     $opt =~ tr/fd//;
     $opt ="-${opt}p";
     $opt =~ tr/ri/Rf/;
     $s->osCmd('cp', $opt, @_)
  }
  else {
     my $rsp =($opt =~/d/i ? 'D' : $opt =~/f/i ? 'F' : '');
     $opt =~s/(r)/SE/i; $opt =~s/(i)/C/i; $opt =~s/[fd]//ig; $opt =~s/(.{1})/\/$1/gi;
     my @cmd =('xcopy',"/H/R/K/Q$opt","\"$src\"","\"$dst\"");
     push @cmd, sub{CORE::print($rsp)} if $rsp && ($ENV{OS} && $ENV{OS}=~/windows_nt/i ? !-e $dst : !-d $dst);
     $s->osCmd(@cmd)
  }
}


#########################################################
# Variables & Logging Methods
#########################################################


sub varFile {   # Common variables filename
 $_[0]->pthForm('var','var.pl');
}


sub varLoad {   # Load common variables
 my ($s, $lck) =@_;
 return($s->{-var}) if $s->{-var} && !$lck;
 my $fn =$s->varFile;
 my $hf;
 if (!-f $fn) {
    $s->{-var} ={'id'=>'DBIx-Web-variables'};
    $s->varStore();
 }
 $hf =$s->hfNew('+<',$fn)->lock($lck||LOCK_SH);
 $s->{-var} =$hf->{-buf} =$hf->load && $s->dsdParse($hf->{-buf});
 $s->{-var}->{'_handle'} =$hf;
 $hf->close() if !$lck;
 $s
}


sub varLock  {	# Lock common variables file
 !$_[0]->{-var} ||!$_[0]->{-var}->{'_handle'}
 ? $_[0]->varLoad($_[1] ||LOCK_EX)
 : $_[0]->{-var}->{'_handle'}->lock($_[1] ||LOCK_EX)
}


sub varStore {  # Store common variables
 my $s  =shift;
 my $hf = !$s->{-var} ||!$s->{-var}->{'_handle'}
        ? $s->hfNew('+>',$s->varFile) 
        : $s->{-var}->{'_handle'};
 delete($s->{-var}->{'_handle'});

 $hf->lock(LOCK_EX)->store($s->dsdMk($s->{-var}))->close();

 $hf->{-buf} =$s->{-var};
 $s->{-var}->{'_handle'} =$hf;
 $s
}


sub logOpen {   # Log File open
 return($_[0]->{-log}) if ref($_[0]->{-log});
 my $fn =$_[0]->pthForm('log','cmdlog.txt');
 $_[0]->{-log} =$_[0]->hfNew('+>>', $fn);
 $_[0]->{-log}->select(sub{$|=1});
 $_[0]->{-log}
}


sub logLock {   # Log File lock
 $_[0]->logOpen if !ref($_[0]->{-log});
 $_[0]->{-log}->lock(@_[1..$#_]);
}


sub logRec {    # Add record to log file
 return(1) if !$_[0]->{-log} && !$_[0]->{-logm};
 $_[0]->logOpen() if $_[0]->{-log} && !ref($_[0]->{-log});
 $_[0]->{-log}->print(strtime($_[0]),"\t",$_[0]->user,"\t",logEsc($_[0],@_[1..$#_]),"\n") if $_[0]->{-log};
 $_[0]->{-c}->{-logm} =[] if $_[0]->{-logm} && !$_[0]->{-c}->{-logm};
 splice @{$_[0]->{-c}->{-logm}}, 2, 2, '...' if $_[0]->{-logm} && scalar(@{$_[0]->{-c}->{-logm}}) >$_[0]->{-logm};
 push @{$_[0]->{-c}->{-logm}}, $_[0]->logEsc(@_[1..$#_]) if $_[0]->{-logm};
 1
}


sub logEsc {	# Escape list for logging
 my $s =$_[0];
 my $b =" ";
 my $r =$_[1] .$b;
 for (my $i=2; $i <=$#_; $i++) {
	my $v =$_[$i];
	$r .=	( !defined($v)
		? 'undef,'
		: ref($v) eq 'ARRAY'
		? '[' .join(', '
			,map {strquot($s, $_);
			} @$v) .'],'
		: isa($v,'HASH')
		? '{' .join(', '
			,map {(defined($_) && $_ =~/^-\w+[\d\w]*$/
				? $_
				: strquot($s, $_)) .'=>' .strquot($s, $v->{$_})
			} sort keys %$v) .'},'
		: $v =~/^\d+$/
		? $v .','
		: $v =~/^-\w+[\d\w]*$/
		? $v .'=>'
		: $v =~/^(select|insert|update|delete|drop|commit|rollback)\s+/i && $i ==2
		? $v .';'
		: (strquot($s, $v) .',')) .$b
 }
 $r =~/^(.+?)[\s,;=>]*$/ ? $1 : $r
}



#########################################################
# User & Group names methods
#########################################################


sub user {	# current user name
 return($_[0]->{-c}->{-user})        if $_[0]->{-c}->{-user};
 $_[0]->{-c}->{-user} =
   $_[0]->{-user}   ? (ref($_[0]->{-user}) ? &{$_[0]->{-user}}(@_) : $_[0]->{-user})
 : $_[0]->{-unames} ? $_[0]->unames->[0]
 : $_[0]->{-ns}->{-guest};
 $_[0]->{-c}->{-user} =$2 .'@' .$1 if $_[0]->{-c}->{-user} =~/^([^\\]+)\\(.+)$/;
#$_[0]->logRec('user', $_[0]->{-c}->{-user});
 $_[0]->{-c}->{-user}
}


sub userln {	# current user local name
 return($_[0]->{-c}->{-userln})        if $_[0]->{-c}->{-userln};
 my $s =$_[0];
 my $un=$s->user();
 my ($d, $u) =	  $un =~/^([^\\]+)\\(.+)$/ ? ($1, $2)
		: $un =~/^([^\@]+)\@(.+)$/ ? ($2, $1)
		: ('', $un);
 $s->{-c}->{-userln} =
	  $^O eq 'MSWin32' && lc($d) eq lc($s->w32domain())
	? $u
	: eval('use Sys::Hostname; Sys::Hostname::hostname()') =~/\Q$d\E$/i
	? $u
	: $un
}


sub uguest {	# is current user a guest
 lc($_[0]->user()) eq lc($_[0]->{-ns}->{-guest})
}


sub unames {	# current user names
 return($_[0]->{-c}->{-unames})        if $_[0]->{-c}->{-unames};
 $_[0]->{-c}->{-unames} =
   $_[0]->{-unames} ? (ref($_[0]->{-unames}) ? &{$_[0]->{-unames}}(@_) : $_[0]->{-unames})
 : $_[0]->{-user}   ? [$_[0]->user()
			, $_[0]->user() =~/^([^\\@]+)([\\@])([^\\@]+)$/
				? ($2 eq '@'	? "$3\\$1"
						: "$3\@$1")
				: ()
			, $_[0]->user() ne $_[0]->userln()
				? ($_[0]->userln())
				: ()
			]		
 : [$_[0]->{-ns}->{-guest}];
 $_[0]->logRec('unames', $_[0]->{-c}->{-unames});
 $_[0]->{-c}->{-unames}
}


sub ugroups {	# current user groups
 return($_[0]->{-c}->{-ugroups})        if $_[0]->{-c}->{-ugroups};
 if ($_[0]->{-ugroups}) {
	return($_[0]->{-c}->{-ugroups} =ref($_[0]->{-ugroups}) eq 'CODE'
		? &{$_[0]->{-ugroups}}(@_)
		: $_[0]->{-ugroups})
 }
 my $s =$_[0];
 my $un=$s->user();
 my $ul=$s->userln();
 my $ug=undef;
 my $fn=undef;
 my $rs='';
 if	(($fn =$s->{-AuthGroupFile}) 
	&& -f $fn) {
	my $fh=$s->hfNew('<', $fn)->lock(LOCK_SH);
	my $ug=[];
	while(my $r =$fh->readline()) {
		next if $r !~/\b(\Q$un\E|\Q$ul\E)\b/;
		next if $r !~/^([^:]+):/;
		push @$ug, $1
	}
	$fh->close();
	$ug =undef if !@$ug;
 }
 elsif	($^O eq 'MSWin32' 
	&& ($s->w32agf()||1)
	&& ($fn =$s->pthForm('var','usergroup')) 
	&& -f $fn) {
	my $fh=$s->hfNew('<', $fn)->lock(LOCK_SH);
	while(my $r =$fh->readline()) {
		if ($r =~/^(?:\w+\\){0,1}\Q$ul\E:(.+)/i
		||  $r =~/^Q$un\E:(.+)/i) {
			$rs=$r;	$r =$1;
			chomp($rs); chomp($r);
			$ug =[split /\t/, $r];
			last
		}
	 }
	 $fh->close();
 }
 if ($ug) {
	$s->{-c}->{-ugroups} =$ug;
	$s->logRec('ugroups', $rs =~/^([^:]+):/ ? $1 : $rs, 'file', $s->{-c}->{-ugroups})
 }
 else {
	$s->{-c}->{-ugroups} =[$s->{-ns}->{-guests}, $s->uguest ? () : ($s->{-ns}->{-users})];
	$s->logRec('ugroups', $un, 'default', $s->{-c}->{-ugroups})
 }
 $s->{-c}->{-ugroups}
}


sub ugnames {	# current user and group names
 if ($_[1]) {
	# return([$_[1]]);
	local $_[0]->{-c}->{-user}	=$_[1];
	local $_[0]->{-c}->{-ugroups}	=undef;
	local $_[0]->{-c}->{-unames}	=undef;
	local $_[0]->{-c}->{-ugrexp}	=undef;
	return($_[0]->ugnames())
 }
 elsif ($_[0]->{-c}->{-ugnames}) {
	return($_[0]->{-c}->{-ugnames})
 }
 $_[0]->{-c}->{-ugnames} =[map {lc $_} @{$_[0]->unames()}, map {lc $_} @{$_[0]->ugroups()}]
}


sub ugrexp {	# current user and group names regexp source
 return($_[0]->{-c}->{-ugrexp}) if $_[0]->{-c}->{-ugrexp};
 my $n =join('|', @{$_[0]->ugnames()}); $n =~s/([\\.?*\$\@])/\\$1/g;
 $_[0]->{-c}->{-ugrexp} =eval('sub{(($_[0]=~/\\b(' . $n.')\\b/i) && $1)}')
}


sub ugmember {	# user group membership
 my $e =$_[0]->{-c}->{-ugrexp} ||ugrexp($_[0]);
 foreach my $i (@_[1..$#_]) {
	if (ref($i))	{foreach my $j (@$i) {defined($j) && &$e($j) && return($_[0]->{-c}->{-user})}}
	else		{defined($i) && &$e($i) && return($_[0]->{-c}->{-user})}
 }
 undef
}


sub uadmin {	# user admin groups membership
 return($_[0]->{-c}->{-uadmin}) if exists($_[0]->{-c}->{-uadmin});
 $_[0]->{-c}->{-uadmin} =ugmember($_[0], $_[0]->{-racAdmin})
}


sub uglist {	# User & Group List
 my $s =shift;
 my $o =defined($_[0]) && substr($_[0],0,1) eq '-' ? shift : '-ug';
 my $r =shift ||[];
 if	($s->{-uglist}) {
	$r =&{$s->{-uglist}}($s, $o, $r)
 }
 elsif	($s->{-AuthUserFile} ||$s->{-AuthGroupFile}) {
	my (@r, $fn);
	$fn =$s->{-AuthUserFile};
	if ($o =~/u/ && $fn && -f $fn) {
		my $fh=$s->hfNew('<', $fn)->lock(LOCK_SH);
		while(my $r =$fh->readline()) {
			push @r, $1 if $r =~/^([^:]+):/
		}
		$fh->close()
	}
	$fn =$s->{-AuthGroupFile};
	if ($o =~/g/ && $fn && -f $fn) {
		my $fh=$s->hfNew('<', $fn)->lock(LOCK_SH);
		while(my $r =$fh->readline()) {
			push @r, $1 if $r =~/^([^:]+):/
		}
		$fh->close()
	}
	$r =ref($r) eq 'HASH'
		? {map {($_ => $_)} @r}
		: [@r]
 }
 elsif	($^O eq 'MSWin32') {
	eval('use Win32API::Net');
	return $r if $@;
	my $sh	=eval{Win32::NodeName()}||$ENV{COMPUTERNAME};
	my $dn=$s->w32domain();
	my $sd	='';	Win32API::Net::GetDCName($sh, $dn||$sh, $sd);
	   $sd	=$sh if !$sd;
	my @g;    
	my %i;
	my $l;
	if ($o =~/g/) {
		my @g;
		Win32API::Net::GroupEnum($sd, \@g)
		|| $s->logRec('Error','uglist','Win32API::Net::GroupEnum',$sd,$!,$^E);
		#|| return(&{$s->{-die}}($s->lng(0,'uglist') .": Win32API::Net::GroupEnum('$sd') -> $!($^E)")||$r);
		if (ref($r) eq 'ARRAY') {
			push(@$r, @g) 
		}
		else {
			foreach my $g (@g) {
				%i =() if !Win32API::Net::GroupGetInfo($sd,$g,1,\%i);
				$l =$i{comment} ||'';
				$r->{$g} =$g .($l ? ', ' .$l :'');
			}
		}
	}
	if ($o =~/g/) {
		my @g;
		Win32API::Net::LocalGroupEnum($sh, \@g)
		|| $s->logRec('Error','uglist','Win32API::Net::LocalGroupEnum',$sh,$!,$^E);
		#|| return(&{$s->{-die}}($s->lng(0,'uglist') .": Win32API::Net::LocalGroupEnum('$sd') -> $!($^E)")||$r);
		if (ref($r) eq 'ARRAY') {
			push(@$r, @g)
		}
		else {
			foreach my $g (@g) {
				%i =() if !Win32API::Net::LocalGroupGetInfo($sh,$g,1,\%i);
				$l =$i{comment} ||'';
				$r->{$g} =$g .($l ? ', ' .$l :'');
			}
		}
	}
	if ($o =~/u/) {
		my @g;
		Win32API::Net::UserEnum($sd, \@g)
		|| $s->logRec('Error','uglist','Win32API::Net::UserEnum',$sd,$!,$^E);
		#|| return(&{$s->{-die}}($s->lng(0,'uglist') .": Win32API::Net::UserEnum('$sd') -> $!($^E)")||$r);
		if (ref($r) eq 'ARRAY') {
			push(@$r, @g)
		}
		else {
			foreach my $g (@g) {
				%i =() if !Win32API::Net::UserGetInfo($sd,$g,10,\%i);
				$l =$i{fullName} || $i{usrComment} ||$i{comment} ||'';
				$r->{$g} =$g .($l ? ', ' .$l :'');
			}
		}
	}
 }
 else {
 }
 $r =[sort {lc($a) cmp lc($b)} @$r] if ref($r) eq 'ARRAY';
 $r
}


sub w32IISdpsn {# deimpersonate Microsoft IIS impersonated process
		# !!!Future: Problems may be. Implement '-fswtr' login also?
		# 'Win32::API' used.
		# Set 'IIS / Home Directory / Application Protection' = 'Low (IIS Process)'
		# or see 'Administrative Tools / Component Services'.
		# Do not use quering to 'Index Server'.
		# See also FastCGI for another ways:
		# http://php.weblogs.com/fastcgi_with_php_and_iis
		# http://www.caraveo.com/fastcgi/
		# http://www.cpan.org/modules/by-module/FCGI/
 return(undef)	if $^O ne 'MSWin32'
		|| !(($ENV{SERVER_SOFTWARE}||'') =~/IIS/)
		|| !$ENV{REMOTE_USER}
		|| $ENV{'GATEWAY_INTERFACE'}
		|| $ENV{'FCGI_SERVER_VERSION'}
		|| $_[0]->{-c}->{-RevertToSelf};
 $_[0]->user();
 $_[0]->{-c}->{-RevertToSelf} =1;
 my $o =eval('use Win32::API; new Win32::API("advapi32.dll","RevertToSelf",[],"N")');
 $o	? $o->Call()
	: &{$_[0]->{-die}}($_[0]->lng(0, 'w32IISdpsn') .": Win32::API('RevertToSelf') -> $@")
}


sub w32domain {	# Win32 domain name
		# !!! domain Name of logged in user may be
    $ENV{DOMAINNAME}
 || (0 && eval('use Win32::OLE; Win32::OLE->CreateObject("ADSystemInfo")->DomainShortName'))
 || eval('use Win32::TieRegistry; $Registry->{\'LMachine\\\\SOFTWARE\\\\Microsoft\\\\Windows NT\\\\CurrentVersion\\\\Winlogon\\\\\\\\CachePrimaryDomain\'} || $Registry->{\'LMachine\\\\SOFTWARE\\\\Microsoft\\\\Windows NT\\\\CurrentVersion\\\\Winlogon\\\\\\\\DefaultDomainName\'}')
 || Win32::DomainName()
}


sub w32agf {	# Win32 Apache 'AuthGroupFile' write/refresh
 my ($s) =@_;
 return(undef) if $^O ne 'MSWin32';
 my @tm=(time());
 my $fn=$s->pthForm('var','usergroup');
 my $uf=60*60;	# Update frequency, every hour = 60*60
 return(undef) if (-f $fn) && (time() -[stat($fn)]->[9] <$uf);
 eval('use Win32API::Net');
 my $fh=$s->hfNew('+>>', $fn)->lock(LOCK_EX);
 return($fh->close() && undef) if -s $fn && time() -[stat($fn)]->[9] <$uf;
 my $sh=eval{Win32::NodeName()}||$ENV{COMPUTERNAME};
 my $dn=$s->w32domain();
 my $sd='';	Win32API::Net::GetDCName($sh, $dn||$sh, $sd);
    $sd=$sh if !$sd;
 my @cl;
 my %cx;
 my %gx;
 $s->logRec('w32agf',-host=>$sh, -dc=>$sd);
 push @tm, time();
 Win32API::Net::LocalGroupEnum($sh, \@cl)
	|| $s->logRec('Error','w32agf','Win32API::Net::LocalGroupEnum',$sh,$!,$^E);
 foreach my $ce (@cl) {
	next if !$ce ||lc($ce) eq 'none';
	my $cc =[];
	Win32API::Net::LocalGroupGetMembers($sh, $ce, $cc)
		|| $s->logRec('Error','w32agf','Win32API::Net::LocalGroupGetMembers',$sh,$ce,$!,$^E);
	$gx{$ce} =$cc;
	foreach my $e (@$cc) {
		next if !$e ||$e =~/\$$/;
		# $e =lc($e);
		$cx{$e} =[] if !exists($cx{$e});
		push @{$cx{$e}}, $ce;
	}
 }
 push @tm, time();
 Win32API::Net::GroupEnum($sd, \@cl)
	|| $s->logRec('Error','w32agf','Win32API::Net::GroupEnum',$sd,$!,$^E);
 foreach my $ce (@cl) {
	next if !$ce ||lc($ce) eq 'none';
	my $cc =[];
	Win32API::Net::GroupGetUsers($sd, $ce, $cc)
		|| $s->logRec('Error','w32agf','Win32API::Net::GroupGetMembers',$sd,$ce,$!,$^E);
	$gx{$ce} =$cc;
	foreach my $e (@$cc) {
		next if !$e ||$e =~/\$$/;
		# $e =lc($e);
		$cx{$e} =[] if !exists($cx{$e});
		push @{$cx{$e}}, $ce;
	}
 }
 push @tm, time();
 $fh->store('');
 foreach my $e (sort {lc($a) cmp lc($b)} keys %cx) {
	my %g =map {($_,1)} @{$cx{$e}};
	while(1) {
		my $c =0;
		foreach my $n (keys %g) {
			next if !$cx{$n};
			foreach my $g (@{$cx{$n}}) {
				next if $g{$g};
				$g{$g} =1;
				$c =1;
			}
		}
		last if !$c;
	}
	my $l =	($e =~/^([^\\]+)\\(.+)$/ ? "$2\@$1" : $e)
		.':' 
		.join("\t", sort map {/^([^\\]+)\\(.+)$/ ? "$2\@$1" : $_} keys %g);
	# $s->logRec('w32agf',$l);
	$fh->print($l,"\n");
 }
 $fh->close();
 push @tm, time();

 $fh=$s->hfNew('+>>', $s->pthForm('var','authgroup'))->lock(LOCK_EX);
 $fh->store('');
 foreach my $e (sort {lc($a) cmp lc($b)} keys %gx) {
	my %g =map {($_,1)} @{$gx{$e}};
	while(1) {
		my $c =0;
		foreach my $n (keys %g) {
			next if !$gx{$n};
			delete $g{$n};
			foreach my $g (@{$gx{$n}}) {
				next if $g{$g};
				$g{$g} =1;
				$c =1;
			}
		}
		last if !$c;
	}
	my $l =	$e .':' 
		.join("\t", sort map {/^([^\\]+)\\(.+)$/ ? ($_, "$2\@$1") : ($_)} keys %g);
	   $l =~s/ /_/g;
	$fh->print($l,"\n");
 }
 $fh->close();
 push @tm, time();

 $s->logRec('w32agf','timing',join('-', map {$tm[$_] -$tm[$_-1]} (1..$#tm)),'sec');
 1
}



#########################################################
# Database methods
#########################################################


sub mdeTable {	# Table MetaData Element
		# (self, table name) -> table metadata
						# Cached
 return	($_[0]->{-table}->{$_[1]})
	if $_[0]->{-table}->{$_[1]}
	&& $_[0]->{-table}->{$_[1]}->{'.mdeTable'};

 my ($s, $tn) =@_;
						# Generate table
						# table factory may be developed
 &{$s->{-mdeTable}}($s, $tn)
	if $s->{-mdeTable} && !$s->{-table}->{$tn};
 return	(&{$s->{-die}}('mdeTable(' .$tn .') -> not described table'))
	if !$s->{-table}->{$tn};
						# Organize table metadata
 $s->logRec('mdeTable', $tn);
 my $tm =$s->{-table}->{$tn};
 $tm->{'.mdeTable'} =1;
 if (ref($tm->{-field}) eq 'ARRAY') {
	foreach my $f (@{$tm->{-field}}) {	# field flags setup
		next if !ref($f) ||ref($f) ne 'HASH';
		$f->{-flg} ='a'			# 'a'll
			if !exists($f->{-flg});
		if ($f->{-flg} =~/k/) {
			if (!$tm->{-key}) {	# 'k'ey
				$tm->{-key} =[$f->{-fld}]
			}
			elsif (!grep {$_ eq $f->{-fld}} @{$tm->{-key}}) {
				push @{$tm->{-key}}, $f->{-fld}
			}
		}
		if ($f->{-flg} =~/w/) {		# 'w'here
			if (!$tm->{-wkey}) {
				$tm->{-wkey} =[$f->{-fld}]
			}
			elsif (!grep {$_ eq $f->{-fld}} @{$tm->{-wkey}}) {
				push @{$tm->{-wkey}}, $f->{-fld}
			}
		}
		$f->{-flg} ='w' .$f->{-flg}	# 'w'here
			if $f->{-flg} !~/w/ && $tm->{-wkey} && grep {$_ eq $f->{-fld}} @{$tm->{-wkey}};
		$f->{-flg} ='k' .$f->{-flg}	# 'k'ey
			if $f->{-flg} !~/k/ && $tm->{-key} && grep {$_ eq $f->{-fld}} @{$tm->{-key}};
		$f->{-flg}.='e'			# 'e'dit
			if $f->{-flg} !~/e/ && $f->{-edit};
	 }
 }
 $tm
}


sub mdlTable {	# Tables List
 sort(	  $_[0]->{-mdlTable}
	?(keys %{$_[0]->{-table}}
		, grep {!$_[0]->{-table}->{$_}} &{$_[0]->{-mdlTable}})
	: keys %{$_[0]->{-table}})
}


sub mdeReaders {# Table readers fields
		# self, table
 my $r =!$_[0]->{-rac} || $_[0]->uadmin() 
 ?      undef
 :	ref($_[1])
 ?	[@{$_[1]->{-racReader} ||$_[0]->{-racReader} ||[]}
	,@{$_[1]->{-racWriter} ||$_[0]->{-racWriter} ||[]}]
 :	[@{$_[0]->{-table}->{$_[1]}->{-racReader} ||$_[0]->{-racReader}||[]}
	,@{$_[0]->{-table}->{$_[1]}->{-racWriter} ||$_[0]->{-racWriter}||[]}];
#$_[0]->logRec('mdeReaders',@_[1..$#_],$r);
 ref($r) && @$r ? $r : undef
}


sub mdeWriters {# Table writers fields
		# self, table
 	!$_[0]->{-rac} || $_[0]->uadmin()
 ?      undef
 :	ref($_[1])
 ?	$_[1]->{-racWriter} ||$_[0]->{-racWriter} ||undef
 :	$_[0]->{-table}->{$_[1]}->{-racWriter} ||$_[0]->{-racWriter} ||undef
}


sub mdeRAC {	# Table record access control condition
 my $m =!ref($_[1]) 
	? $_[0]->{-table}->{$_[1]}
	: $_[1]->{-table}
	? $_[0]->{-table}->{$_[1]->{-table}}
	: $_[1];
	( $m->{-racPrincipal}	||$_[0]->{-racPrincipal} 
	||$m->{-racActor}	||$_[0]->{-racActor} 
	||$m->{-racWriter}	||$_[0]->{-racWriter} 
	||$m->{-rvcUpdBy}	||$_[0]->{-rvcUpdBy}
	) && $m
}


sub mdeRole {	# Table user role fields list
		# self, table, role
 my $m =ref($_[1]) ? $_[1] : $_[0]->{-table}->{$_[1]};
 my $r =$_[2] eq 'author'
 ?	[$m->{-rvcInsBy} ||$_[0]->{-rvcInsBy} ||()
	,$m->{-rvcUpdBy} ||$_[0]->{-rvcUpdBy} ||()]
 :	$_[2] eq 'authors'
 ?	$m->{-racWriter} ||$_[0]->{-racWriter} ||mdeRole($_[0], $m, 'author')
 :	$_[2] eq 'actors'
 ?	$m->{-racActor} ||$_[0]->{-racActor} ||$m->{-rvcUpdBy} ||$_[0]->{-rvcUpdBy} ||mdeRole($_[0], $m, 'authors')
 :	$_[2] eq 'principals'
 ?	$m->{-racPrincipal} ||$_[0]->{-racPrincipal} ||$m->{-rvcInsBy} ||$_[0]->{-rvcInsBy} ||mdeRole($_[0], $m, 'author')
 :	mdeRole($_[0], $m, 'authors');
 ref($r) && @$r ? $r : undef
}


sub recType {   # Record type or table name
 $_[1]->{-table}
 || ($_[1]->{-form} && $_[0]->{-form}->{$_[1]->{-form}} && $_[0]->{-form}->{$_[1]->{-form}}->{-table})
 || (ref($_[2]) ne 'HASH' && substr($_[2], 0, index($_[2],'='))) # class name
}


sub recFields { # Field names in the record hash
 sort grep {substr($_,0,1) ne '-' && substr($_,0,1) ne '.'} keys %{$_[1]}
}


sub recValues { # Field values in the record hash
 map {$_[1]->{$_}} recFields($_[0], $_[1])
}


sub recData {   # Field name => value hash ref
 return({map {($_=> $_[1]->{$_})} recFields($_[0], $_[1])})
}


sub recKey {	# Record's key: field => value hash ref
		# self, table name, record
 my $m =$_[0]->{-table}->{$_[1]} ||$_[0]->{-form}->{$_[1]};
   $m && $m->{-key}
 ? {map {($_=>$_[2]->{$_})}  @{$m->{-key}}}
 : $_[2]->{'id'}		# 'id' field present
 ? {'id'=>$_[2]->{'id'}}
 : {}
}


sub recWKey {	# Record's optimistic key: field => value hash ref
		# self, table name, record
 my $m =$_[0]->{-form}->{$_[1]} ||$_[0]->{-table}->{$_[1]};
 return(recKey(@_)) if !$m;
 my $r ={};
 if	($m->{-wkey}) {
	$r ={map {($_=>$_[2]->{$_})
		}  grep {defined($_[2]->{$_})
			} @{$m->{-wkey}}}
 }
 %$r ? $r : recKey(@_)
}


sub rmlClause { # Command clause words and values list from record's hash ref
		# (record manipulation language)
 map {($_=>$_[1]->{$_})} sort grep {substr($_,0,1) eq '-'} keys %{$_[1]}
}


sub rmlKey {  # Record's '-key' clause value
                # ($self, {command}, {data})
   $_[1]->{-key} && !ref($_[1]->{-key})		# should be translated
 ? {'id'=>rmlIdSplit(@_[0,1],$_[1]->{-key})}
 : $_[1]->{-key}				# already exists
 ? $_[1]->{-key}
 : $_[1]->{-where}				# not needed using '-where'
 ? $_[1]->{-key}
 : $_[0]->{-table}->{$_[1]->{-table}}->{-key}	# key described
 ? {(map {($_=>$_[2]->{$_})} 
	@{$_[0]->{-table}{$_[1]->{-table}}->{-key}})}
 : $_[2]->{'id'}				# 'id' field present
 ? {'id'=>rmlIdSplit(@_[0,1],$_[2]->{'id'})}
 : undef
}


sub rmlIdSplit {# Split record ID into table name and real ID
		# ($self, {command}, key value)
  !$_[0]->{-idsplit} 
 ? $_[2]
 : ref($_[0]->{-idsplit}) 
 ? &{$_[0]->{-idsplit}}(@_)
 : $_[2] =~m/([^\Q$RISM0\E]+)\Q$RISM1\E((?:.(?!\Q$RISM1\E))+)$/
 ? eval{$_[1]->{-table}=$1; $2}	# 'table//rowid', table !~m!/!, rowid !~m!//!
 : $_[2]
}


sub rmiTrigger {# Execute trigger
		# (record manipulation internal)
                # self, {command}, {data}, {record}, trigger names
 local $_[0]->{-affect}	=undef;
 local $_[0]->{-rac}	=undef;
 my $tbl =$_[0]->{-table}->{$_[1]->{-table}};
 my $frm =$_[0]->{-form}->{$_[1]->{-form}} if $_[1]->{-form} && $_[0]->{-form};
 foreach my $t (@_[4..$#_]) {
	&{$_[0]->{$t}}($_[0], $_[1], $_[2], $_[3]) if $_[0]->{$t} && !($t eq '-recInsID' && $tbl->{$t});
	&{$tbl->{$t}} ($_[0], $_[1], $_[2], $_[3]) if $tbl->{$t};
	&{$frm->{$t}} ($_[0], $_[1], $_[2], $_[3]) if $frm && ($frm->{$t} ne $tbl->{$t});
 }
 $_[0]
}


sub rmiIndex {  # Index record
		# {-table=>name}, {newData=>value}, {oldData=>value}
 my ($s, $a, $d, $r) =@_;
 my  $n =$d; # {%$r} ||{}; $n->{keys %$d} =values %$d;
 my  @q =([undef,'-'],[undef,'+']);
 local $s->{-affect}	=undef;
 local $s->{-rac}	=undef;
 if (my $m =$s->{-table}->{$a->{-table}}->{-recIndex0R}) {
	&$m($s, $a, $d, $r)
 }
 foreach my $x (keys %{$s->{-table}}) {
	next if !ref($s->{-table}->{$x}->{-ixcnd});
	my $i =$s->{-table}->{$x};
	$q[0]->[0] =$r && &{$i->{-ixcnd}}($s, $a, $r) ? $r : 0; # delete
	$q[1]->[0] =$d && &{$i->{-ixcnd}}($s, $a, $n) ? $n : 0; # insert/update
	foreach my $q (@q) {
		next if !$q->[0];
		my $v =	  $i->{-ixrec} 
			? &{$i->{-ixrec}}($s, $a, $q->[0], $q->[1])
			: $i->{-field} && ref($i->{-field}) eq 'ARRAY'
			? {map {$q->[0]->{$_}} grep {ref($_) && $_->{-fld}} @{$i->{-field}}}
			: $i->{-field} && ref($i->{-field}) eq 'HASH'
			? {map {$q->[0]->{$_}} keys %{$i->{-field}}}
			: undef;
		foreach my $r (!ref($v) ? () : ref($v) eq 'ARRAY' ? @$v : ($v)) {
			my $k =rmlKey($s, {-table=>$x}, $r);
			$q->[1] eq '-'
			? $s->dbiDel({-table=>$x, -key=>$k}, $r)
			: $s->dbiUpd({-table=>$x, -key=>$k, -save=>1}, $r);
		}
	}
 }
 $d
}


sub recIndex {	# Update/delete index entry, for calls from '-recIndex0R'
		# index name, {key}, {data}||undef
 !$_[0]->{-table}->{$_[1]}->{-ixcnd}
 ? &{$_[0]->{-die}}('recIndex(' .$_[1] .') -> not described index')
 : $_[3]
 ? $_[0]->dbiUpd({-table=>$_[1], -key=>$_[2], -save=>1}, $_[$#_])
 : $_[0]->dbiDel({-table=>$_[1], -key=>$_[2]});
}


sub recReindex{	# Reindex database
		# self, clear, indexes
 my ($s, $c, @i) =@_;
 $s->varLock();
 my @t =grep {!$s->{-table}->{$_}->{-ixcnd}} $s->mdlTable();
    @i =grep { $s->{-table}->{$_}->{-ixcnd}} keys %{$s->{-table}} if !@i;
 if ($c) {
	foreach my $i (@i) {
		$s->dbiTrunc($i);
	}
 }
 foreach my $t (@t) {
	$s->logRec('recReindex', $t);
	my $a ={-table=>$t,-version=>1};
	my $c =$s->recSel(%$a);
	my $r;
	while ($r =$c->fetchrow_hashref()) {
		$s->logRec('recReindex',$r);
		$s->rmiIndex($a, $r)
	}
 }
 $s
}


sub rfdName {	# Record's files directory name
		# self, command |table name, record data, subdirectory,...
 my $t =ref($_[1]) ? $_[1]->{-table} : $_[1];
 my $m =$_[0]->{-table}->{$t};
 join('/'
	, $_[2]->{$m->{-rvcActPtr} ||$_[0]->{-rvcActPtr} ||'-none'}
	? 'v'
	: 'a'
	, $t
	, &{$m->{-rfdName} 
	||$_[0]->{-rfdName} 
	||sub{		my $r ='';
			foreach my $e (@_[1..$#_]) {
				for (my $i =0; $i <=length($e); $i +=3) {
					my $v =substr($e, $i, 3);
					# $v =~s/([,;+:'"?*%\/\\])/uc sprintf("%%%02x",ord($1))/eg;
					$v =~s/([^a-z0-9_-])/uc sprintf("%%%02x",ord($1))/eg;
					$r .=$v .'/'
				}
			}
			chop($r);
			$r
		}}(
		$_[0]
		, map {	defined($_[2]->{$_}) ? $_[2]->{$_} : $_[1]->{-key}->{$_}
			} @{$m->{-key}})
	. $RISM2
	, map {	my $v =$_; 
		$v =~s/([,;+:'"?*%])/uc sprintf("%%%02x",ord($1))/eg;
		$v} @_[3..$#_]	# encoding as 'rfaUpload'
	)
}


sub rfdPath {	# Record's files directory path
		# self, -path|-url|-urf, rfdName |{data} |({command}|table, {data}), ?subdirectory...
 join('/'
	, $_[0]->{$_[1]} .'/rfa'
	, !ref($_[3]) # rfdName, !ref($_[2]) && !ref($_[3])
	? ((ref($_[2]) 
		? $_[2]->{-file} 
		|| return(&{$_[0]->{-die}}('rfdPath(' .$_[0]->strdata(@_) .') -> no file attachments')||'')
		: $_[2])
	, map {	my $v =$_;
		$v =~s/([,;+:'"?*%])/uc sprintf("%%%02x",ord($1))/eg;
		$v} @_[3..$#_])	# encoding as 'rfdName' and 'rfaUpload'
	: rfdName($_[0],@_[2..$#_]))
}


sub rfdEdmd {	# Record's files directory editing allowed?
		# self, command |table name, record data
 my $u =$_[0]->{-table}->{
		ref($_[1]) 
		? ($_[1]->{-table} || $_[1]->{-form} && $_[0]->{-form}->{$_[1]->{-form}}->{-table})
		: ($_[0]->{-table}->{$_[1]} && $_[1] ||$_[0]->{-form}->{$_[1]}->{-table})
		}->{-rvcFinState} 
	||$_[0]->{-rvcFinState};
 my $r =$_[2];
 $u && $r->{$u->[0]}
		  && !grep {$r->{$u->[0]} eq $_} @{$u}[1..$#{@$u}];
}


sub rfdStamp {	# Stamp record with files directory name, create if needed
		# self, command |table name, record data, acl set
 my $d =rfdName(@_[0..2]);
 my $p =rfdPath($_[0],-path=>$d);
 my $e =rfdEdmd(@_[0..2]);
 my $r =$_[2];
 my $w =$_[3];

 $_[0]->pthMk($p) if $e;

 if (-d $p)	{ $r->{-file} =$d	}
 else		{ delete $r->{-file}	}

 if ($r->{-file} && $w) {	# set ACL
	my $s =$_[0];
	my $m =$s->{-table}->{ref($_[1]) ? $_[1]->{-table} : $_[1]};
	my $wr=$m->{-racReader} ||$s->{-racReader};
	   $wr=[map {defined($r->{$_}) ? (split /\s*[,;]\s*/i, $r->{$_}) : ()} @$wr] if $wr;
	my $ww=$m->{-racWriter} ||$s->{-racWriter};
	   $ww=[map {defined($r->{$_}) ? (split /\s*[,;]\s*/i, $r->{$_}) : ()} @$ww] if $ww;
	if ($wr ||$ww) {
		my @wa=	map {$_ =~s/ /_/g; $_}
			map {$_ =~/^([^\\@]+)([\\@])([^\\@]+)$/ ? ($_, $3 .($2 eq '@' ? '\\' : '@') .$1) : $_}
			(map {ref($_) ? @$_ : ()} $s->{-fswtr}, $s->{-fsrdr}, $ww, $wr);
		my $wf=$s->hfNew('+>',"$p/.htaccess");
		$wf->store('<Files "*">', "\n"
			,"require user\t"	.join(' ',@wa), "\n"
			,"require group\t"	.join(' ',@wa), "\n"
			,'</Files>',"\n");
		$wf->close();
	}
	if (($wr ||$ww) && $^O eq 'MSWin32' && Win32::IsWinNT()) { # $ENV{OS} && $ENV{OS}=~/Windows_NT/i
		$p =~s/\//\\/g;
		$s->osCmd('cacls', "\"$p\"", '/T','/C','/G'
		,(map{(m/([^@]+)\@([^@]+)/ ? "$2\\$1" : $_) .':F'} ref($s->{-fswtr}) ? (@{$s->{-fswtr}}) : ($s->{-fswtr}))
		,$s->{-fsrdr}
		?(map{(m/([^@]+)\@([^@]+)/ ? "$2\\$1" : $_) .':R'} ref($s->{-fsrdr}) ? (@{$s->{-fsrdr}}) : ($s->{-fsrdr}))
		:()
		,sub{CORE::print "Y\n"});
		if ($e && $ww) {
			foreach my $u (map {m/([^@]+)\@([^@]+)/ ? "$2\\$1" : $_} @$ww) {
				$s->osCmd('cacls', "\"$p\""
				, '/E','/T','/C','/G', $u .':F')
			}
			foreach my $u (map {m/([^@]+)\@([^@]+)/ ? "$2\\$1" : $_} $wr ? @$wr : ()) {
				$s->osCmd('cacls', "\"$p\""
				, '/E','/T','/C','/G', $u .':R')
			}
		}
		else {
			foreach my $u (map {m/([^@]+)\@([^@]+)/ ? "$2\\$1" : $_
					} map {$_ ? @$_ : ()} $ww, $wr) {
				$s->osCmd('cacls', "\"$p\""
				, '/E','/T','/C','/G', $u .':R')
			}
		}
	}
 }

 $r->{-file}
}


sub rfdCp {	# Copy record's files directory to another record
		# self, source {record} |rfdName, dest {command} |table, {record}
 my $fd =ref($_[1]) ? $_[1]->{-file} : $_[1];
    return(0) if !$fd;
 my $fp =rfdPath($_[0],-path=>$fd);
    return(0) if ! -d $fp;
 my $td =rfdName($_[0], @_[2..$#_]);
 my $tp =rfdPath($_[0],-path=>$td);
 $_[0]->pthMk($tp) && $_[0]->pthCp('-r',$fp,$tp)
 && ($_[3]->{-file} =$td);
}


sub rfdRm {	# Remove record's files directory
		# self, rfdName |{record} |({command} |table, {record})
 my $p =rfdPath($_[0], -path=>ref($_[1]) && $_[1]->{-file} ? $_[1]->{-file} : @_[1..max($_[0], 2, $#_)]);
    $p =$_[0]->pthRm('-r', $p) && $_[0]->pthCln($p);
 delete $_[1]->{-file} if $p && ref($_[1]);
 $p
}


sub rfdCln {	# Clean record's files directory, delete if empty
		# self, rfdName |{record} |({command} |table, {record})
 my $p =rfdPath($_[0], -path=>ref($_[1]) && $_[1]->{-file} ? $_[1]->{-file} : @_[1..max($_[0], 2, $#_)]);
    $p =$_[0]->pthCln($p);
 delete $_[1]->{-file} if $p && ref($_[1]) && !-d $p;
 $p
}


sub rfdGlobn {	# Glob record's files directory, return attachments names
		# self, rfdName |{record} |({command} |table, {record}), subdirectory...
 $_[0]->pthGlobn($_[0]->rfdPath(-path=>@_[1..$#_]) .'/*')
}


sub rfaRm {	# Delete named attachment(s) in record's files directory
		# self, rfdName |{record} |({command} |table, {record}), attachment|[attachments]
 grep {$_[0]->pthRm('-r',$_[0]->rfdPath(-path=>@_[1..$#_-1], $_))
	} ref($_[$#_]) ? @{$_[$#_]} : $_[$#_]
}


sub rfaUpload {	# Upload named attachment into record's files directory
		# self, rfdName |{record} |({command} |table, {record}), cgi file
 my $fn =$_[0]->cgi->param($_[$#_]);
    $fn =$fn =~/[\\\/]([^\\\/]+)$/ ? $1 : $fn;
    $fn =~s/([,;+:'"?*%])/uc sprintf("%%%02x",ord($1))/eg;
 my $fh =$_[0]->cgi->upload($_[$#_])
        ||return(&{$_[0]->{-die}}($_[0]->lng(0,'rfaUpload') ."('" .$_[$#_] ."') CGI::upload -> " .$_[0]->lng(1,'rfaUplEmpty') ."\n"));
 binmode($fh);
 eval('use File::Copy');
 File::Copy::copy($fh, $_[0]->rfdPath(-path=>@_[1..$#_-1], $fn))
 || &{$_[0]->{-die}}($_[0]->lng(0,'rfaUpload') ."('" .$_[$#_] ."'): File::Copy::copy -> $!\n");
 eval{close($fh)};
}


sub recNew {    # Create new record to be inserted into database
		# -table=>name, field=>value || -data=>{values}
		# -key=>sample
 my	$s =$_[0];
	$s->logRec('recNew', @_[1..$#_]);
 my	$a =(@_< 3 && ref($_[1]) ? $_[1] : {@_[1..$#_]});
 my	$d =$a->{-data} ? $a->{-data} : $a;
 local	$a->{-table} =recType ($s, $a, $d);
 local	$a->{-key}   =rmlKey($s, $a, $d);
 my	$m =mdeTable($s,$a->{-table});
 my	$r ={%$d};
 my	$p =(grep {$_} values %{$a->{-key}}) ? $s->recRead(%$a, -data=>undef, -test=>1) : {};
 rmiTrigger($s, $a, $r, $p, qw(-recNew0R));
 foreach my $w (qw(-rvcInsBy -rvcUpdBy)) {foreach my $c ($m, $s) {
	next if !$c->{$w}; $r->{$c->{$w}} =$s->user; last
 }}
 foreach my $w (qw(-rvcInsWhen -rvcUpdWhen)) {foreach my $c ($m, $s) {
	next if !$c->{$w}; delete $r->{$c->{$w}}; last
 }}
 foreach my $w (qw(id -file)) {
	 delete $r->{$w};
 }
 $r->{-new} =$s->strtime();
 $r->{-editable} =$s->user() if $s->{-rac} && ($m->{-racWriter}||$s->{-racWriter});
 rmiTrigger($s, $a, $d, $r, qw(-recNew1R -recJoint1R -recNew1C));
 $d
}


sub recForm {   # Recalculate record - new or existing
		# -table=>name, field=>value || -data=>{values}
		# -key=>original
 my	$s =$_[0];
	$s->logRec('recForm', @_[1..$#_]);
 my	$a =(@_< 3 && ref($_[1]) ? $_[1] : {@_[1..$#_]});
 my	$d =$a->{-data} ? $a->{-data} : $a;
 local	$a->{-table} =recType ($s, $a, $d);
 local	$a->{-key}   =rmlKey($s, $a, $d);
 my	$r =(!$d->{-new} && (grep {$_} values %{$a->{-key}}) && $s->recRead(%$a,-data=>undef,-test=>1)) ||{};
	map {$r->{$_} =$d->{$_}} keys %$d;
 rmiTrigger($s, $a, $d, $r, qw(-recForm1R -recJoint1R -recForm1C));
 $r
}


sub recIns {    # Insert record into database
		# -table=>table, field=>value || -data=>{values}
		# -key=>{sample}, -from=>cursor
 my	$s =$_[0];
	$s->varLock if $s->{-serial} && $s->{-serial} ==1;
	$s->logRec('recIns', @_[1..$#_]);
 my	$a =(@_< 3 && ref($_[1]) ? {%{$_[1]}} : {@_[1..$#_]});
 my	$d =$a->{-data} ? {%{$a->{-data}}} : $a;
 local  $a->{-table}=recType ($s, $a, $d);
 local	$a->{-key}  =rmlKey($s, $a, $d);
 my	$m =mdeTable($s,$a->{-table});
 my	$r =undef;
 my	$v =$m->{-rvcActPtr}	||$s->{-rvcActPtr};
 my	$b =$m->{-rfa}	||$s->{-rfa};
 my	$p =(grep {$_} values %{$a->{-key}}) && $s->recRead(%$a, -data=>undef, -test=>1);
 if ($p) {		# form record with prototype
    my $t =recData($s, $p);
    delete $t->{$v};
    @{$t}{keys %$d} =values %$d;
    $a eq $d ? ($a =$d =$t) : ($d =$t)
 }
 rmiTrigger($s, $a, $d, $r, qw(-recIns0C));
 foreach my $w (qw(-rvcInsBy -rvcUpdBy)) {foreach my $c ($m, $s) {
	next if !$c->{$w}; $d->{$c->{$w}} =$s->user; last
 }}
 foreach my $w (qw(-rvcInsWhen -rvcUpdWhen)) {foreach my $c ($m, $s) {
	next if !$c->{$w}; $d->{$c->{$w}} =$s->strtime; last
 }}
 if ($a->{-from}) {	# insert from cursor
	while (my $t =$a->{-from}->fetchrow_hashref()) {
		$t ={%$t};	# readonly hash
		rfdStamp($s, $a, $t) if $b;
		@{$t}{recFields($s, $d)} =recValues($s, $d);
		rmiTrigger($s, $a, $t, $r, qw(-recForm1R -recIns0R -recInsID));
		rfdCp	  ($s, $t->{-file}, $a, $t) if $t && $t->{-file};
		rfdCp	  ($s, $p->{-file}, $a, $t) if $p && $p->{-file};
		rmiIndex  ($s, $a, $t) if $m->{-index} ||$s->{-index};
		$r =$s->dbiIns($a, $t);
		rfdStamp($s, $a, $r, '+') if $t && $t->{-file} || $p && $p->{-file};
		rmiTrigger($s, $a, $t, $r, qw(-recIns1R)) if $r;
	}
	$r =$a;
 }
 else {			# insert single record
	rmiTrigger($s, $a, $d, $r, qw(-recForm1R -recIns0R -recInsID));
	rfdCp	  ($s, $p, $a, $d)	if $p && $p->{-file};
	rmiIndex  ($s, $a, $d, undef)	if $m->{-index} ||$s->{-index};
	$r =$s->dbiIns($a, $d);
	rfdStamp  ($s, $a, $r, '+');	# if $p && $p->{-file};
	rmiTrigger($s, $a, $d, $r, qw(-recIns1R -recJoint1R)) if $r;
 }
 $r->{-editable} =$s->user if $r && $s->{-rac} && ($m->{-racWriter}||$s->{-racWriter});
 rmiTrigger($s, $a, $d, $r, qw(-recIns1C)) if $r;
 $r
}


sub dbiIns {    # Insert record into database
		# -table=>table, field=>value
		# -save=>boolean
 my ($s, $a, $d) =@_;
 my  $f =$a->{-table};
 my  @c;
 my  $r =$a;
     $s->{-affected} =0;
 if (($s->{-table}->{$f}->{-dbd} ||$s->{-dbd} ||$s->{-ns}->{-dbd}) eq 'dbi') {
	my  @a =recFields($d);
	@c=( 'INSERT INTO ' .$f .' (' .join(',', @a) 
		.') VALUES (' .join(',', map {'?'} @a) .')'
		,(map {$d->{$_}} @a)
	);
	$s->logRec('dbiIns', @c);
	$s->dbi->do(@c)|| return(&{$s->{-die}}($s->lng(0,'dbiIns') .": do() -> " .$DBI::errstr) && undef);
	$s->{-affected} =$DBI::rows;
	return($a) if $DBI::rows >1 ||$a->{-save};
	@a =grep {defined($d->{$_})} @a;
	@c =('SELECT * FROM ' .$f .' WHERE '
		.join(' AND ', map {$_ .'=?'} @a)
		,(map {$d->{$_}} @a));
	$s->logRec('dbiIns', @c);
	$r =$s->dbi->selectrow_hashref(@c) || return(&{$s->{-die}}($s->lng(0,'dbiIns') .": selectrow_hashref() -> " .$DBI::errstr) && undef);
 }
 elsif (($s->{-table}->{$f}->{-dbd} ||$s->{-dbd} ||$s->{-ns}->{-dbd}) eq 'dbm') {
	@c =	([map {$d->{$_}} 
			@{$s->{-table}->{$f}->{-key}}]
		,($r =recData($s, $d)));
	$s->logRec('dbiIns/kePut', $f, @c);
	$s->dbmTable($f)->kePut(@c) || return(&{$s->{-die}}($s->lng(0,'dbiIns') .": kePut() -> $@") && undef);
 }
 elsif (($s->{-table}->{$f}->{-dbd} ||$s->{-dbd} ||$s->{-ns}->{-dbd}) eq 'xmr') {
 }
 $r
}


sub dbiExplain {# Explain DML plan
 my $s =shift;
 return() if !$s->{-debug};
 my $i =ref($_[0]) ? shift : $s->dbi;
 my $q =shift;
 eval {
   my $c =$i->prepare("explain $q");
       $c->execute;
    my $r;
    while ($r =$c->fetchrow_hashref()) {
      $s->logRec('dbiExplain', join(', ', map {"$_=> " .$s->strquot($r->{$_})} @{$c->{NAME}}));
    }
 }
}


sub recUpd {    # Update record(s) in database
		# -table=>table, field=>value || -data=>{values}
		# -key=>{field=>value}, -where=>'condition'
		# -optrec=>boolean
 my	$s =$_[0];
	$s->varLock if $s->{-serial} && $s->{-serial} ==1;
	$s->logRec('recUpd', @_[1..$#_]);
 my	$a =(@_< 3 && ref($_[1]) ? {%{$_[1]}} : {@_[1..$#_]});
 my	$d =$a->{-data} ? {%{$a->{-data}}} : $a;
 local  $a->{-table}=recType ($s, $a, $d);
 local	$a->{-key}  =rmlKey  ($s, $a, $d);
 my	$m =mdeTable($s,$a->{-table});
 my	$r =undef;
 my	$w =mdeWriters($s, $m);
 my	$u =$m->{-rvcFinState}	||$s->{-rvcFinState};
 my	$o =$m->{-rvcCkoState}	||$s->{-rvcCkoState};
 my	$v =$m->{-rvcActPtr}	||$s->{-rvcActPtr};
 my	$i =$m->{-index}	||$s->{-index};
 my	$b =$m->{-rfa}		||$s->{-rfa};
 my	$e =undef;
 local  $a->{-version}= ref($a->{-version})
			? $a->{-version}
			: $v
			? [$v, @{$m->{-rvcDelState} ||$s->{-rvcDelState} ||[]}]
			: undef;
 foreach my $c ($m, $s) {
	next if !$c->{-rvcUpdBy}; $d->{$c->{-rvcUpdBy}} =$s->user; last
 }
 foreach my $c ($m, $s) {
	next if !$c->{-rvcUpdWhen}; $d->{$c->{-rvcUpdWhen}} =$s->strtime; last
 }
 rmiTrigger($s, $a, $d, $r, qw(-recUpd0C));
 if ($w ||$u ||$i ||grep {$s->{$_} || $m->{$_}} qw(-recUpd0R -recUpd -recUpd1R)) {
	my $c =$s->recSel(rmlClause($s, $a), -data=>undef);
	my $j =0;
	while ($r =$c->fetchrow_hashref()) {
		$j++; return(&{$s->{-die}}($s->lng(0,'recUpd') .": $j ". $s->lng(1,'-affected')) && undef)
			if $s->{-affect} && $j >$s->{-affect};
		# $r ={%$r};	# readonly hash, should be considered below
		return(&{$s->{-die}}($s->lng(0,'recUpd') .': ' .$s->lng(1,'recUpdAclStp')) && undef)
			if $w && !$s->ugmember(map {$r->{$_}} @$w);
		rfdStamp($s, $a, $r) if $b;
		if    ($v && $r->{$v}) {			# prohibit version
			return(&{$s->{-die}}($s->lng(0,'recUpd') .': ' .$s->lng(1,'recUpdVerStp')) && undef)
		}
		elsif ($o && ($r->{$o->[0]}||'') eq $o->[1] 
			  &&  defined($a->{$o->[0]})
			  &&  $a->{$o->[0]} ne $o->[1]) {	# check-in
			my $t =$r->{'id'};
			$e =$s->recUpd(%$r, %{recData($s,$d)}
					, 'id'=>$r->{$v}, $v=>undef
					, -table=>$a->{-table}, -key=>$r->{$v});
			rfdRm	($s, $r)	    if $r->{-file};
			rmiIndex($s, $a, undef, $r) if $i;
			$s->dbiDel({-table=>$a->{-table}, -key=>$t});

		}
		elsif ($o && ($r->{$o->[0]}||'') ne $o->[1] 
			  && ($a->{$o->[0]}||'') eq $o->[1]) {	# check-out
			$e =$s->recIns(%$r, %{recData($s,$d)}, $v=>$r->{'id'}
					, -table=>$a->{-table}, -key=>$r->{'id'})
		}
		elsif ($u && $r->{$u->[0]}
			  && grep {$r->{$u->[0]} eq $_} 
					@{$u}[1..$#{@$u}]) {	# version
			my $n ={%$r}; @{$n}{recFields($s, $d)} =recValues($s, $d);
			my $p ={%$r, $v=>$r->{'id'}, -table=>$a->{-table}};
			rmiTrigger($s, $a, $n, $r, qw(-recForm1R -recUpd0R));
			rmiTrigger($s, $a, $p, undef, qw(-recInsID));
			rfdCp	  ($s, $r->{-file}, $a, $p) if $r && $r->{-file};
			rfdRm	  ($s, $a, $n)
			&& rfdCp  ($s, $a->{-file}, $a, $n) 
					if $a->{-file}
					&& (!$r->{-file} || $r->{-file} ne $a->{-file});
			rfdStamp  ($s, $a, $n, '+');
			rmiIndex  ($s, $a, $n, $r) if $i;
			rmiIndex  ($s, $a, $p)	   if $i;
			$p =$s->dbiIns($p, $p);
		}
		else {						# update only
			my $n ={%$r}; @{$n}{recFields($s, $d)} =recValues($s, $d);
			rmiTrigger($s, $a, $n, $r, qw(-recForm1R -recUpd0R));
			rfdStamp  ($s, $a, $n, '+') if $r && $r->{-file};
			rfdCln	  ($s, $a, $n)      if $r && $r->{-file} && $u && $n->{$u->[0]} && grep {$n->{$u->[0]} eq $_} @{$u}[1..$#{@$u}];
			rmiIndex  ($s, $a, $n, $r)  if $i;
		}
	}
	$r =$e || $s->dbiUpd($a, $d);
 }
 else {
	$r =$s->dbiUpd($a, $d);
 }
 return(&{$s->{-die}}($s->lng(0,'recUpd') .': ' .($s->{-affected}||0) .' ' .$s->lng(1,'-affected')) && undef)
	if $s->{-affect} && (($s->{-affected}||0) != $s->{-affect});
 if ($r && ($s->{-affected}||0) ==1) {
	rfdStamp($s, $a, $r) if $b;
	$r->{-editable} =$w ? $s->ugmember(map {$r->{$_}} @$w) : $s->user
			if $s->{-rac};
	rmiTrigger($s, $a, $d, $r, qw(-recJoint1R));
 }
 rmiTrigger($s, $a, $d, $r, qw(-recUpd1C)) if $r;
 $r
}


sub dbiUpd {    # Update record(s) in database
		# -table=>table, field=>value || -data=>{values}
		# -key=>{field=>value}, -where=>'condition'
		# -save=>boolean, -optrec=>boolean
 my ($s, $a, $d) =@_;
 my  $f =$a->{-table};
 my  @c;
 my  $r =undef;
     $s->{-affected} =0;
 if (($s->{-table}->{$f}->{-dbd} ||$s->{-dbd} ||$s->{-ns}->{-dbd}) eq 'dbi') {
	my @a  =recFields($d);
	my @cn =$a->{-key} ? sort keys %{$a->{-key}}	: ();
	my @cv =$a->{-key} ? map {$a->{-key}->{$_}} @cn	: ();
	@c=('UPDATE '. $f .' SET '
		.join(',', map {"$_=?"} @a)
		." WHERE "
		.join(' AND '	
			, (map {"$_=?"} @cn)		# Key condition
			, $a->{-where} 
			? '(' .$a->{-where} .')' 	# Where condition 
			: ()
			, $a->{-version} 		# Version control
			? ("($f." .$a->{-version}->[0] ." IN(NULL,'') AND $f." .$a->{-version}->[1] ." <> '" .$a->{-version}->[2] ."')")
			: ()
			, dbiLsLike($s, $f, undef	# Access control
				,mdeWriters($s, $f), $s->ugnames())
			)
		,map {$d->{$_}} @a
		,@cv
	);
	$s->logRec('dbiUpd',@c);
	$s->dbi->do(@c) || return(&{$s->{-die}}($s->lng(0,'dbiUpd') .": do() -> " .$DBI::errstr) && undef);
	$s->{-affected} =$DBI::rows;
	$s->logRec('dbiUpd','affected',$DBI::rows);
	return($s->dbiIns($a, $d)) 
		if !$DBI::rows 
		&& ($a->{-save}
		||  $s->{-table}->{$f}->{-ixcnd});
	return($s->recIns($a, $d))
		if !$DBI::rows
		&& ($a->{-optrec}
		||  $s->{-table}->{$f}->{-optrec});
	return($a) if $DBI::rows >1 ||$a->{-save};
	@cn =grep {defined($d->{$_}||defined($a->{-key}->{$_}))} @cn;
	@c =('SELECT * FROM ' .$f .' WHERE '
		.join(' AND '	, (map {"$_=?"} @cn)
				, $a->{-where} ? '(' .$a->{-where} .')' : ())
		,(map {defined($d->{$_}) ? $d->{$_} : $a->{-key}->{$_}} @cn)
	);
	$s->logRec('dbiUpd',@c);
	$r =$s->dbi->selectrow_hashref(@c) || return(&{$s->{-die}}($s->lng(0,'dbiUpd') .": selectrow_hashref() -> " .$DBI::errstr) && undef);
 }
 elsif (($s->{-table}->{$f}->{-dbd} ||$s->{-dbd} ||$s->{-ns}->{-dbd}) eq 'dbm') {
	my $h =$s->dbmTable($f);
	my @f =recFields($s,$d);
	my @v =recValues($s,$d);
	my $j =0;
	$s->{-affected} =
	$s->dbmSeek($a, sub {
			$j++;
			return(&{$s->{-die}}($s->lng(0,'dbiUpd') .": $j ". $s->lng(1,'-affected')) && undef)
				if $s->{-affect} && $j >$s->{-affect};
			$r =$_[2];
			@{$r}{@f} =@v;
			my $k =[map {$r->{$_}} @{$s->{-table}->{$f}->{-key}}];
			$s->logRec('dbiUpd/kePut', $f, $k, $_[1], $r);
			$h->kePut($k, $_[1], $r);
	});
	if (!$s->{-affected}) {
		return($s->dbiIns($a, $d)) 
			if $a->{-save} || $s->{-table}->{$f}->{-ixcnd};
		return($s->recIns($a, $d))
			if $a->{-optrec} || $s->{-table}->{$f}->{-optrec};
		return(&{$s->{-die}}($s->lng(0,'dbiUpd') .": dbmSeek() -> " .($@ ||'not found')) && undef)
	}
	$r =$s->{-affected} >1 ? $a : $r;
 }
 $r
}


sub dbmSeek {	# Select records from dbm file using -key and -where
 my ($s, $a, $e) =@_;
 my $m =$s->{-table}->{$a->{-table}};			# metadata
 my $i =$m->{-key};					# index
 my $k =($a->{-key}					# key index part
	? [map {$a->{-key}->{$_}} grep {exists $a->{-key}->{$_}} @$i] 
	: []);
 my $wk={ $a->{-key}					# key where part
	? (map {($_=>$a->{-key}->{$_})} (grep {my $v =$_; !grep {$v eq $_} @$i} keys %{$a->{-key}}))
	: ()
	};
    $wk=undef if !%$wk;
 my $o =($a->{-keyord} ||$a->{-orderby} ||$a->{-order})	# order request
	|| (!$e && (!@$k) ? $KSORD : '-aeq');
    $o ='-' .$o if substr($o,0,1) ne '-';
 my $ox=@$k						# order execute
	? $o 
	: $e 
	? $o 
	: $o =~/^-[af]/ 
	? '-aall' 
	: '-dall';
 my $ws;						# 'where' key cond
 if ($wk) {
	$ws =substr($o, 2);
	$ws =0 ? undef
	: $ws eq 'eq' || $ws eq 'all'
		      ? sub{my($k,$v,$d); foreach $k (keys %$wk) {
				$v =$wk->{$k};	$d =$_[2]->{$k}; 
				return(undef) if
				  !defined($d)	? defined($v)
				: !defined($v)	? defined($d)
				: $d =~/^[\d\.]+\$/ && $v =~/^[\d\.]+\$/
				? $d != $v	: $d ne $v;
			}; 1}
	: $ws eq 'ge' ? sub{my($k,$v,$d); foreach $k (keys %$wk) {
				$v =$wk->{$k};	$d =$_[2]->{$k}; 
				return(undef) if
				  !defined($d)	? defined($v)
				: !defined($v)	? 0
				: $d =~/^[\d\.]+\$/ && $v =~/^[\d\.]+\$/
				? $d < $v	: $d lt $v;
			}; 1}
	: $ws eq 'gt' ? sub{my($k,$v,$d); foreach $k (keys %$wk) {
				$v =$wk->{$k};	$d =$_[2]->{$k}; 
				return(undef) if
				  !defined($d)	? 1
				: !defined($v)	? !defined($d)
				: $d =~/^[\d\.]+\$/ && $v =~/^[\d\.]+\$/
				? $d <= $v	: $d le $v;
			}; 1}
	: $ws eq 'le' ? sub{my($k,$v,$d); foreach $k (keys %$wk) {
				$v =$wk->{$k};	$d =$_[2]->{$k}; 
				return(undef) if
				  !defined($d)	? 0
				: !defined($v)	? defined($d)
				: $d =~/^[\d\.]+\$/ && $v =~/^[\d\.]+\$/
				? $d > $v	: $d gt $v;
			}; 1}
	: $ws eq 'lt' ? sub{my($k,$v,$d); foreach $k (keys %$wk) {
				$v =$wk->{$k};	$d =$_[2]->{$k}; 
				return(undef) if
				  !defined($d)	? !defined($v)
				: !defined($v)	? 0
				: $d =~/^[\d\.]+\$/ && $v =~/^[\d\.]+\$/
				? $d >= $v	: $d ge $v;
			}; 1}
	: undef
 }
 my $wa=$a->{-urole} && !$a->{-uname}			# 'where' access cond
	? mdeRole($s, $m, $a->{-urole})
	: mdeReaders($s, $m);
 my $wr=   $a->{-uname} 				# 'where' role cond
	&& $a->{-urole} 
	&& mdeRole($s, $m, $a->{-urole});
 if ($wr) {
	my $wl	=$wr;
	my $wn	=$s->ugnames($a->{-uname});
	$wr	=sub {	foreach my $v (@$wl) {
				foreach my $n (@$wn) {
					return($n) if $_[2]->{$v} =~/\b\Q$n\E\b/i
				}
			}
			undef
	}
 }
 my $wv=$a->{-version};					# 'where' version cond
    $wv=undef if $wv && !@$wv;
 my $ft=$a->{-ftext};					# full-text find
 my $wf=$a->{-filter};					# 'where' filter expr
 my $wc=$a->{-where};					# 'where' condition
 my $we=$wc;						# 'where' cond source
 if (defined($wc) && !ref($wc) && $wc) {		# ... from string
	# !!! perl operations incompatible with SQL
	my $wm =$we; $we =''; 
	my ($wa, $wt, $wq);
	while (length($wm)) {
		$wa =!$wa;
		if ($wm =~/(?<!\\)((?:\\\\)*["'])/) {	# ... unescaped quote
			$wt =$`; $wm =$'; $wq =$1;
		}
		else {
			$wt =$wm; $wm =''; $wq ='';
		}
		if ($wa) {				# ... translate expr
			$wt =~s/((?<![><=])=)/'=' .$1/ge;
			$wt =~s/({\w+\})/'$_->' .$1/ge;
			$wt =~s/\b((?<!\{)\w{1,}(?!\s*\())\b/my $v =$1; $v !~\/^(?:and|or|eq|ge|gt|le|lt)$\/i ? '$_->{' .$v .'}' : $v/ge;
		}					# !!! good expr syntax?
		$we .=$wt .$wq;
	}
	$wc =$s->ccbNew($we);
 }
 my $w =sub{local $_ =$_[2];				# 'where' construct
	   (!$wv || (!$_[2]->{$wv->[0]} && (!$wv->[1] ||!$_[2]->{$wv->[1]} ||$_[2]->{$wv->[1]} ne $wv->[2])))
	&& (!$ws || &$ws(@_))
	&& (!$wc || &$wc(@_))
	&& (!$wa || ugmember($s, map {$_[2]->{$_}} @$wa))
	&& (!$wr || &$wr(@_))
	&& (!$ft || grep {defined($_[2]->{$_}) && $_[2]->{$_} =~/\Q$ft\E/i} keys %{$_[2]})
	&& (!$wf || &$wf(@_))
	};
 $s->logRec('dbmSeek'
	, $a->{-table}, $ox, $k
	, $wv	? (-version=> $wv)	: ()
	, $wk	? ('-' .substr($o, 2)=>$wk)	 : ()
	, $we	? (-where=>$we)		: ()
	, $wa	? (-rac	=>$wa)		: ()
	, $wr	? (-urole=>$a->{-urole}, -uname=>$a->{-uname})	: ()
	, $ft	? (-ftext=>$ft)		: ()
	, $wf	? (-filter=>$wf)	: ()
	, $e	? (-subw=>$e)		: ()
	);
 $s->dbmTable($a->{-table})->keSeek($ox,$k,$w,$e);
}


sub dbiKeyWhr {	# SQL -key -order query condition
		# self, {command}, key field names
 my ($s, $a, @cn);
    @cn =$a->{-key} ? sort keys %{$a->{-key}} : () if !@cn;
   !@cn && return(@cn);
 my $kc =$a->{-keyord} ||$a->{-order};
    $kc =!$kc || ref($kc) || substr($kc,0,1) ne '-'
	? ''
	: {'eq'=>'=','ge'=>'>=','gt'=>'>','le'=>'<=','lt'=>'<'}->{substr($kc,2)}||'=';
 map {$kc ? "?$kc$_" : "?=$_"} @cn
}


sub dbiLsLike {	# SQL List LIKE or RLIKE
		# self, table, operation, [fields], [values]
 return(!$_[2] ? () : '') if !$_[3] ||!$_[4] || !@{$_[3]} ||!@{$_[4]};
 my $l	=$_[0]->dbi->{Driver}->{Name} eq 'mysql'
	? ' RLIKE ' 
		.$_[0]->dbi->quote('[[:<:]](' 
				.join('|', @{$_[4]}) 
				.')[[:>:]]')	# "REGEXP is case insensitive for normal (not binary) strings"
	: $_[4];
 ' ' .$_[2] .' '
	. ref($l)
	? '(' .join(' OR '			# !!! precession
		, map {	my $f =$_;
			map {$f .' LIKE ' .$_[0]->dbi->quote('%' .$_ .'%')
				} @$l
			} @{$_[3]}) .')'
	: '(' .join(' OR ', map {$_ .$l} @{$_[3]}) .')'
}


sub recDel {    # Delete record(s) in database
		# -table=>table
		# -key=>{field=>value}, -where=>'condition'
 my	$s =$_[0];
	$s->varLock if $s->{-serial} && $s->{-serial} ==1;
	$s->logRec('recDel', @_[1..$#_]);
 my	$a =(@_< 3 && ref($_[1]) ? {%{$_[1]}} : {@_[1..$#_]});
 my	$d =$a->{-data} ? $a->{-data} : $a;
 local  $a->{-table}=recType($s, $a, $d);
 local	$a->{-key}  =rmlKey($s, $a, $d);
 my	$m =mdeTable($s,$a->{-table});
 my	$r =undef;
 my	$w =mdeWriters($s, $m);
 my	$u =$m->{-rvcDelState}	||$s->{-rvcDelState};
 my	$i =$m->{-index}	||$s->{-index};
 my	$b =$m->{-rfa}		||$s->{-rfa};
 rmiTrigger($s, $a, $d, $r, qw(-recDel0C));
 if ((($w||$i) && !$u) ||grep {$s->{$_} || $m->{$_}} qw(-recDel0R -recDel -recDel1R)) {
	my $c =$s->recSel(rmlClause($s, $a), -data=>undef);
	my $j =0;
	while ($r =$c->fetchrow_hashref()) {
		$j++; return(&{$s->{-die}}($s->lng(0,'recDel') .": $j ". $s->lng(1,'-affected')) && undef)
			if $s->{-affect} && $j >$s->{-affect};
		# $r ={%$r};	# readonly hash, should be considered below
		return(&{$s->{-die}}($s->lng(0,'recDel') .': ' .$s->lng(1,'recDelAclStp')) && undef)
			if $w && !$s->ugmember(map {$r->{$_}} @$w);
		rfdStamp  ($s, $a, $r)		if $b;
		rmiTrigger($s, $a, $d, $r, qw(-recDel0R));
		rfdRm	  ($s, $r)		if !$u && $r->{-file};
		rmiIndex  ($s, $a, undef, $r)	if !$u && $i;
	}
	$r =($u ? $s->recUpd(-table=>$a->{-table}, -key=>$a->{-key}, -where=>$a->{-where}, @$u) 
		: $s->dbiDel($a, $d));
 }
 else {
	$r =($u	? $s->recUpd(-table=>$a->{-table}, -key=>$a->{-key}, -where=>$a->{-where}, @$u) 
		: $s->dbiDel($a, $d));
 }
 return(&{$s->{-die}}($s->lng(0,'recDel') .': ' .($s->{-affected}||0) .' ' .$s->lng(1,'-affected')) && undef)
	if $s->{-affect} && (($s->{-affected}||0) != $s->{-affect});
 rmiTrigger($s, $a, $d, $r, qw(-recDel1C)) if $r;
 $r
}


sub dbiDel {    # Delete record(s) in database
		# -table=>table
		# -key=>{field=>value}, -where=>'condition'
 my ($s, $a, $d) =@_;
 my $f =$a->{-table};
 my @c;
 my $r;
     $s->{-affected} =0;
 if (($s->{-table}->{$f}->{-dbd} ||$s->{-dbd} ||$s->{-ns}->{-dbd}) eq 'dbi') {
	my @cn =$a->{-key} ? sort keys %{$a->{-key}}	: ();
	my @cv =$a->{-key} ? map {$a->{-key}->{$_}} @cn	: ();
	@c =('DELETE FROM ' .$f .' WHERE '
		.join(' AND '
			, (map {"$_=?"} @cn)		# Key condition
			, $a->{-where} 
			? '(' .$a->{-where} .')' 	# Where condition
			: ()
			, dbiLsLike($s, $f, undef	# Access control
				, mdeWriters($s, $f), $s->ugnames())
			)
		,@cv
	);
	$s->logRec('dbiDel', @c);
	$s->dbi->do(@c) || return(&{$s->{-die}}($s->lng(0,'dbiDel') .": do() -> " .$DBI::errstr) && undef);
	$s->{-affected} =$DBI::rows;
	$s->logRec('dbiDel','affected',$DBI::rows);
	return($DBI::rows && $a);
 }
 elsif (($s->{-table}->{$f}->{-dbd} ||$s->{-dbd} ||$s->{-ns}->{-dbd}) eq 'dbm') {
	my $h =$s->dbmTable($f);
	my $j =0;
	$s->{-affected} =
	$s->dbmSeek($a, sub {
		$j++; return(&{$s->{-die}}($s->lng(0,'dbiDel') .": $j " .$s->lng(1,'-affected')) && undef)
			if $s->{-affect} && $j >$s->{-affect};
                $s->logRec('dbiDel/keDel', $f, $_[1]);
		$h->keDel($_[1]);
	});
	return(&{$s->{-die}}($s->lng(0,'dbiDel') .": dbmSeek() -> $@") && undef) if !defined($s->{-affected});
 }
 $s->{-affected} && $a
}


sub dbiTrunc {	# Clear all records in the datafile
		# self, datafile name
 my ($s, $f) =@_;
 my @c;
 if (($s->{-table}->{$f}->{-dbd} ||$s->{-dbd} ||$s->{-ns}->{-dbd}) eq 'dbi') {
     @c =('TRUNCATE TABLE ' .$f);
     $s->logRec('dbiTrunc', @c);
     $s->dbi->do(@c) || return(&{$s->{-die}}($s->lng(0,'dbiTrunc') .": do() -> " .$DBI::errstr) && undef);
 }
 elsif (($s->{-table}->{$f}->{-dbd} ||$s->{-dbd} ||$s->{-ns}->{-dbd}) eq 'dbm') {
	my $n =$s->pthForm('dbm',$f);
	if (-e $n) {
		$s->logRec('dbiTrunc','unlink', $n);
		unlink($n)
		|| return(&{$s->{-die}}($s->lng(0,'dbiTrunc') .": unlink('$n') -> $!") && undef)
	}
 }
 $s
}


sub recSel {    # Select records from database
		# see 'dbiSel'
 my	$s =$_[0];
 my	$a =@_< 3 && ref($_[1]) ? dsdClone($s, $_[1]) : {map {ref($_) ? dsdClone($s, $_) : $_} @_[1..$#_]};
	$a->{-table}=recType($s, $a, $a);
 my	$m =mdeTable($s,$a->{-table});
	$a->{-version}= ref($a->{-version})
			? $a->{-version}
			: $m && (!$a->{-version} ||$a->{-version} eq '-')
			? [ ($m->{-rvcActPtr}   ||$s->{-rvcActPtr}   ||())
			  ,@{$m->{-rvcDelState} ||$s->{-rvcDelState} ||[]}]
			: undef;
 $s->{-fetched} =0;
 rmiTrigger($s, $a, undef, undef, qw(-recSel0C));
 $s->dbiSel($a);
}


sub recList {	# List records from database
 recSel(@_)	# - reserved to be redesigned
}


sub recRead {   # Read one record from database
		# -key=>{field=>value}, see 'dbiSel'
		# -optrec=>boolean, -test=>boolean
 my	$s =$_[0];
 my	$a =@_< 3 && ref($_[1]) ? dsdClone($s, $_[1]) : {map {ref($_) ? dsdClone($s, $_) : $_} @_[1..$#_]};
 my	$d ={};
 local	$s->{-affect}=1;
	$a->{-table}=recType($s, $a, $d);
	$a->{-key}  =rmlKey($s, $a, $d);
	$a->{-data} =ref($a->{-data}) ne 'ARRAY' ? undef : $a->{-data};
 my	$m =mdeTable($s,$a->{-table});
 my	$r =undef;
 rmiTrigger($s, $a, $d, $r, qw(-recRead0C -recRead0R));
 $r =$s->dbiSel($a)->fetchrow_hashref();
 if ($r) {
	$s->{-affected} =1;
	$s->{-fetched}  =1;
 }
 else {
	$s->{-affected} =0;
	$s->{-fetched}  =0;
	return(undef)
		if $a->{-test};
 	return(&{$s->{-die}}($s->lng(0,'recRead') .': ' .($s->{-affected}||0) .' ' .$s->lng(1,'-affected')) && undef)
		if !$a->{-optrec}
		|| !$m->{-optrec};
	return($s->recNew(map {($_=>$a->{$_})} grep {$a->{$_}} qw(-table -form)));
 }
 if ($r && $s->{-rac}) {
	return(&{$s->{-die}}($s->lng(0,'recRead') .': '. $s->lng(1,'recReadAclStp')) && undef)
	if !$s->uadmin() 
	&&($m->{-racWriter} ||$s->{-racWriter} ||$m->{-racReader} ||$s->{-racReader})
	&& !$s->ugmember(map {$r->{$_}}	 @{$m->{-racWriter} ||$s->{-racWriter}||[]}
					,@{$m->{-racReader} ||$s->{-racReader}||[]});
	$r->{-editable} =$s->user()
		if $s->ugmember(map {$r->{$_}} @{$m->{-racWriter} ||$s->{-racWriter}||[]})
 }
 rfdStamp($s, $a, $r) if $m->{-rfa} ||$s->{-rfa};
 rmiTrigger($s, $a, $d, $r, qw(-recRead1R -recJoint1R -recRead1C)) if $r;
 $r
}


sub dbiSel {    # Select records from database
		# -data		=>[fields] | [field, [field=>alias], {-fld=>alias, -expr=>formula,..}]
		# -table	=>[tables] | [[table=>alias], [table=>alias,join]]
		# -key		=>{field=>value}
		# -where	=>string   | [strings]
		# -ftext	=>string
		# -version	=>0|1
		# -order	=>string   | [field, [field=>order]]
		# -keyord	=>-(a|f|d|b)(all|eq|ge|gt|le|lt)
		# -group	=>string   | [field, [field=>order]]
		# -filter	=>sub{}(cursor, undef, {field=>value,...})
 my ($s, $a) =@_;
 my  $t =$a->{-table};
 my  $f =ref($t) ? $t->[0] : $t =~/^([^\s]+)/ ? $1 : $t;
 my  @c;
 my  $r;
 if (($s->{-table}->{$f}->{-dbd} ||$s->{-dbd} ||$s->{-ns}->{-dbd}) eq 'dbi') {
	my @cn =$a->{-key} ? sort keys %{$a->{-key}}	: ();
	my @cv =$a->{-key} ? map {$a->{-key}->{$_}} @cn	: ();
	my $kn =$s->{-table}->{$f} && $s->{-table}->{$f}->{-key} ||[];
	@c =('SELECT '						# Data
		. (!$a->{-data}		? ' * '
		: !ref($a->{-data})	? ' ' .$a->{-data} .' '
		: ref($a->{-data}) ne 'ARRAY' ? ' * '
		: join(', '
			, map {!ref($_) 
			? $_
			: ref($_) ne 'HASH'
			? join(' AS ', @$_[0..1])
			: (defined($_->{-expr}) 
				? $_->{-expr} .' AS ' .$_->{-fld} 
				: $_->{-fld})
			} @{$a->{-data}}))
		. ' FROM '					# From
		. (!ref($t) 
			? $t 
			: join(' '
				, (map {!ref($_) 
					? ($_,',') 
					: (@$_, $_->[$#_] =~/(JOIN|,)$/i 
						? () 
						: ',')} @$t)[0..-1]))
		. ' WHERE '					# Where
		. join(' AND '
			, dbiKeyWhr($s, $a, @cn)		# Key condition
			, $a->{-where}				# Where condition
			? '(' .(!ref($a->{-where}) 
				? $a->{-where} 
				: join(' AND ', map {$_
					} @{$a->{-where}})) 
			  .')' 
			: ()
			, $a->{-version}			# Version switch
			? ("($f." .$a->{-version}->[0] 
				." IN(NULL,'') AND $f." 
				.$a->{-version}->[1] ." <> '" 
				.$a->{-version}->[2] ."')")
			: ()

			, !($a->{-urole} && $a->{-uname})	# Access control
			? ()
			: dbiLsLike($s, $f, undef
				, mdeReaders($s, $f), $s->ugnames())
			, !$a->{-urole}				# Role filter
			? ()
			: dbiLsLike($s, $f, undef
				, mdeRole($s, $f, $a->{-urole})
				, $a->{-uname}
				? $s->ugnames($a->{-uname})
				: $s->ugnames())
			, !$a->{-ftext}				# Full-text
			? ()
			: ref($a->{-data} eq 'ARRAY')
			? '(' .join(' OR '
				, map {(!ref($_) 
					? $_ 
					: ref($_) ne 'HASH'
					? $_->[1]
					: $_->{-fld})
					. ' LIKE ' 
					.$s->dbi->quote('%' .$a->{-ftext} .'%')
					} grep {$_ && (ref($_) ne 'HASH' || $_->{-fld})
						} @{$a->{-data}}
				, $s->{-table}->{$f}->{-ftext}
				? map {	$_
					. ' LIKE ' .$s->dbi->quote('%' .$a->{-ftext} .'%')
					} @{$s->{-table}->{$f}->{-ftext}}
				: ()
			  ) .')'
			: $s->{-table}->{$f}->{-ftext}
			? '(' .join(' OR '
				, map {	$_
					. ' LIKE '. $s->dbi->quote('%' .$a->{-ftext} .'%')
					} @{$s->{-table}->{$f}->{-ftext}}
			  ) .')'
			: $s->{-table}->{$f}->{-field}
			? '(' .join(' OR '
				, map {	$_->{-fld}
					. ' LIKE ' .$s->dbi->quote('%' .$a->{-ftext} .'%')
					} grep {ref($_) eq 'HASH' && $_->{-fld} && ($_->{-flg}||'') =~/[akwuql]/
						} @{$s->{-table}->{$f}->{-field}}
			  ) .')'
			: ()
			, @cn	||$a->{-where} ||$a->{-version} 
				||$a->{-urole}
				||$a->{-ftext} 
			? () 
			: ('TRUE')
			)
		. ($a->{-order}					# Order by
		  ? ' ORDER BY '
			.ref($a->{-order})
			? join(', ',map {!ref($_) ? $_ : join(' ',@$_)} @{$a->{-order}})
			: substr($a->{-order},0,1) ne '-'
			? $a->{-order}
			: $a->{-order} =~/-[af]/
			? join(',', @$kn)
			: join(',', map {"$_ desc"} @$kn)
		  : $a->{-keyord}				# -keyord
		  ? ' ORDER BY '
			.$a->{-keyord} =~/-[af]/
			? join(',', @$kn)
			: join(',', map {"$_ desc"} @$kn)
		  : '')
		. ($a->{-group}					# Group by
		  ? ' GROUP BY '
			.ref($a->{-group})
			? join(', ',map {!ref($_) ? $_ : join(' ',@$_)} @{$a->{-group}})
			: $a->{-group}
		  : '')
		. ($a->{-having}				# Having
		  ? ' HAVING ' .$a->{-having}
		  : '')
	);
	$s->logRec('dbiSel', @c);
	$r =$s->dbi->prepare(@c) || return(&{$s->{-die}}($s->lng(0,'dbiSel') .": prepare() -> " .$DBI::errstr) && undef);
	$r->execute(@cv) || return(&{$s->{-die}}($s->lng(0,'dbiSel') .": execute() -> " .$DBI::errstr) && undef);
	$r =DBIx::Web::dbiCursor->new($r, -flt=>$a->{-filter}) if $a->{-filter};
	$r->{-rec} ={map {($_=>undef)} @{$r->{NAME}}};
	$r->{-rfr} =[map {\($r->{-rec}->{$_})} @{$r->{NAME}}];
	$r->{-flt} =$a->{-filter};
	$r->bind_columns(undef, @{$r->{-rfr}});
	$s->dbiExplain(@c) if $s->{-debug} && $s->dbi->{Driver}->{Name} eq 'mysql';
 }
 elsif (($s->{-table}->{$f}->{-dbd} ||$s->{-dbd} ||$s->{-ns}->{-dbd}) eq 'dbm') {
	$r =$s->dbmSeek($a);
	return(&{$s->{-die}}($s->lng(0,'dbiSel') .": dbmSeek() -> $@") && undef) if !defined($r);
	if	($a->{-data} && (ref($a->{-data}) eq 'ARRAY')) {
		$r->setcols($a->{-data})
	}
	elsif	(my $m =$s->{-table}->{$f}->{-field}) {
		$r->setcols(ref($m) eq 'HASH' 
			? keys %$m
			: map {$_->{-fld}} grep {(ref($_) eq 'HASH') && $_->{-fld}} @$m)
	}
 }
 $r
}


sub recCommit {	# commit changes in the database
 $_[0]->logRec('recCommit');
 if ($_[0]->{-dbi}) {
	$_[0]->{-dbi}->commit 
	|| return(&{$_[0]->{-die}}($_[0]->lng(0,'recCommit') .": commit() -> " .$DBI::errstr) && undef)
 }
 $_[0]
}


sub recRollback {# rollback changes in the database
 $_[0]->logRec('recRollback');
 if ($_[0]->{-dbi}) {
	$_[0]->{-dbi}->rollback
	|| return(&{$_[0]->{-die}}($_[0]->lng(0,'recRollback') .": rollback() -> " .$DBI::errstr) && undef)
 }
 $_[0]
}


#########################################################
# CGI User Interface
#########################################################


sub cgiRun {	# Execute CGI query
 my $s =$_[0];
 my $r;
		# Automatic upgrade
 if ($s->{-setup} && !$ARGV[0]) {
 	my $ds =(stat(main::DATA))[9] ||0;
	my $dv =($ds && (stat($s->varFile()))[9])||0;
	$ARGV[0] ='-setup' if $ds >$dv;
 }
		# Command line service options
 if ($ARGV[0]) {
	$s->start();
	print "Content-type: text/plain\n\n";
	print "'$0' service operation: '" .$ARGV[0] ."'...\n";
	if ($ARGV[0] eq '-reindex') {
		$r =$s->recReindex(1);
	}
	elsif ($ARGV[0] eq '-setup') {
		$r =$s->setup();
		$s->varStore();
	}
	# print "'$0' service operation: '" .$ARGV[0] ."'->$r\n";
	return($s)
 }
		# Error display handler
 my $he =sub{
	return if $^S;
	delete $s->{-pcmd}->{-xml} if $s->{-pcmd};
	my $e =$_[0]; chomp($e);
	eval{$s->logRec('Die', $e)};
	eval{$s->recRollback()};
	eval{$s->htmlStart()} if !*fatalsToBrowser && !$s->{-c}->{-httpheader};
	eval{ # $e =htmlEscape($s, $e);
		$e =~s/[\n\r]/<br \/>\n/g;
		$s->output('<span class="_ErrorMessage"><hr />'
		,'<h1>', 'Error '
		, htmlEscape($s, lng($s, 0, ($s->{-pcmd} && $s->{-pcmd}->{-cmd})||'Open'))
		, '@'
		, htmlEscape($s, lng($s, 0, ($s->{-pcmd} && $s->{-pcmd}->{-cmg})||'Start'))
		, "</h1>\n"
		, $e, "</span>\n");
	     $s->cgiFooter();
	     $s->output("<hr />\n")};
	eval{$s->end()};
	};
 if (*fatalsToBrowser)	{$SIG{__DIE__} ='DEFAULT'; !*CGI::Carp::set_message{CODE} && eval('use CGI::Carp'); CGI::Carp::set_message($he)}
 else			{$SIG{__DIE__} =$he}

		# Start operation
 $s->start();
 $s->set(-autocommit=>0);
 local $s->{-affect} =1;

 # cmg transitions:
 # global       commands
 # -------      --------
 # recList:	recList,	  recForm, recQBF->
 # recQBF:	recQBF,  	  recForm, recList->
 # recNew:	recNew,  	  recForm, recIns->
 # recRead:	recRead, recEdit, recForm, recIns, recUpd, recDel->, recNew->
 # recDel:			  recForm
 # recForm?			  recForm

		# Accept & parse CGI params, find form, command, global command, key...
 $s->cgiParse();
 my $oa =$s->{-pcmd}->{-cmd};
 my $og =$s->{-pcmd}->{-cmg};
 my $on =$s->{-pcmd}->{-form} ||'default';
 my ($om, $oc);

		# Login redirection, if needed
 if ($s->{-pcmd}->{-login} && $s->uguest()) {
	print $s->cgi->redirect(-uri=>$s->urlAuth(), -nph=>(($ENV{SERVER_SOFTWARE}||'') =~/IIS/) ||($ENV{MOD_PERL} && !$ENV{PERL_SEND_HEADER}));
	$s->end();
	return($s);
 }

 while(1) {	# Determine / Delegate operation object requested / Execute
	$s->{-pcmd}->{-form} =$on;
	if	($s->{-form}  && $s->{-form}->{$on})	{$oc ='f'; $om =$s->{-form}->{$on}}
	elsif	($s->{-table} && $s->mdeTable($on))	{$oc ='t'; $om =$s->mdeTable($on)}
	else						{$oc ='' ; $om =undef}
	return(&{$s->{-die}}($s->lng(0,'cgiRun') .": Operation object '$on' not found") && undef) if !$om;
	$s->{-pcmd}->{-table} =($oc eq 't' ? $on : $om->{-table});

					# redirectional implemtation: '-cgcURL'
	foreach my $e (map {$om->{$_}} ('-cgcURL', '-redirect')) {
		next if !defined($e);
		last if !$e;
		print $s->cgi->redirect(-uri=>$e, -nph=>(($ENV{SERVER_SOFTWARE}||'') =~/IIS/) ||($ENV{MOD_PERL} && !$ENV{PERL_SEND_HEADER}));
		$s->end();
		return($r);
	}
					# external implemtation: '-cgcXXX'
	foreach my $e (map {$om->{"-cgc$_"}}
			 $oa =~/^rec(.+)/ ? $1 : $oa
			,$og =~/^rec(.+)/ ? $1 : $og, 'Call') {
		next if !defined($e);
		last if !$e;
		$_ =$s;
		$r =	ref($e) 
			? &$e($s, $on, $om, $s->{-pcmd}, $s->{-pdta})
			: $e =~/\.psp$/i
			? $s->psEval('-', $e, undef, $on, $om, $s->{-pcmd}, $s->{-pdta})
			: do($e);
		$s->end(); # 'recCommit' inside
		return($r)
	}

	my $nxt;			# delegation - substitute object
	foreach my $v (map {$om->{"-$_"}} ('subst', $oa
			, $oa eq 'recList' && $og eq 'recQBF' 
			? ('qlist')
			: $og =~/rec(New|Read|Del|QBF)/ 
			? ($og, 'recForm') 
			: $og)) {
		next if !defined($v) || ref($v);
		last if !$v;
		$on = $nxt =$v;
		last
	}
	next if $nxt;
	
	last;
 }

		# Execute action
 if	(ref(my $e =$om->{"-$oa"}) eq 'CODE') {
	$s->{-pout} =&$e($s, $on, $om, $s->{-pcmd}, $s->{-pdta});
 }
 else	{
	$s->{-pout} =$s->cgiAction($on, $om, $s->{-pcmd}, $s->{-pdta});
 }

		# Reassign form if changed
 $s->{-pcmd}->{-form} =$on =(isa($s->{-pout}, 'HASH') && $s->{-pout}->{-form}) 
			|| $s->{-pcmd}->{-form} ||$on;

		# Execute external presentation '-cgvXXX'
 foreach my $e (map {$om->{"-cgv$_"}}
		 $oa =~/^rec(.+)/ ? $1 : $oa
		,$og =~/^rec(.+)/ ? $1 : $og, 'Call') {
	next if !defined($e);
	last if !$e;
	$_ =$s;
	$r =	  ref($e)
		? &$e($s, $on, $om, $s->{-pcmd}, $s->{-pout})
		: $e =~/\.psp$/i 
		? $s->psEval('-', $e, undef, $on, $om, $s->{-pcmd}, $s->{-pout})
		: do($e);
	$s->end(); # 'recCommit' inside
	return($r);
 }

		# Execute predefined presentation implementation
 $s->output(	 $s->htmlStart()		# HTTP/HTML/Form headers
		,$s->htmlHidden($on, $om)	# common hidden fields
		,$s->htmlMenu($on, $om)		# Menu bar
	);
 $s->cgiForm($on, $om, $s->{-pcmd}, $s->{-pout}) if $s->cgiHook('recFormRWQ');
 $s->cgiList($on, $om, $s->{-pcmd}, $s->{-pout}) if $s->cgiHook('recList');
 $s->recCommit();
 $s->cgiFooter();
 $s->htmlEnd();
 $s->end();
 $s
}


sub cgiParse {	# Parse CGI call parameters
 my ($s) =@_;
 my $g =$s->cgi;
 my $d =$g->Vars;
 $s->{-pcmd} ={};
 $s->{-pdta} ={};
 $s->{-lng} =$g->http('Accept_language')||'';
 $s->{-lng} =$s->{-lng} =~/^([^ ;,]+)/ ? $1 : $s->{-lng};
 foreach my $k (keys %$d) {
	next if !defined($d->{$k} || $d->{$k} eq '');
	if ($k =~/^_(cmd|cmg|frmCall|frmName\d*|recNew|recRead|recPrint|recEdit|recIns|recUpd|recDel|recForm|recList|recQBF|submit.*|app.*|form|key|qkey|qwhere|qurole|quname|qftext|qversion|qorder|qlist|qlimit|qftwhere|qftord|edit|backc|login|print|xml)(?:\.[xXyY]|__S){0,1}$/i) {
		my ($c, $v) =($1, $d->{$k});
		if ($k =~/^(.+)\.[xXyY]$/) {
			$g->param($1, 1);
			$g->delete($k);
			$v=1;
		}
		elsif ($k =~/^(.+)__S$/) {
			$v =$d->{$1 .'__L'};
			$g->delete($k);
		}
		if ($c =~/^(?:rec|frmCall|submit)/i) {
			$s->{-pcmd}->{-cmd} =$c
		}
		else {
			$s->{-pcmd}->{"-$c"}=$v
		}
	}
	elsif($k =~/^_(new|file)$/) {
		$s->{-pdta}->{"-$k"} =$d->{$k}
	}
	elsif($k =~/^(.+)__S$/) {	# assign 'cgiDDLB' choise
		$s->{-pdta}->{$1} =$d->{$1 .'__L'};
	}
	else {
		$s->{-pdta}->{$k} =$d->{$k}
	}
 }
 my $c =$s->{-pcmd};

 $c->{-cmg} ='recList' 
		if !$c->{-cmg} && !$c->{-cmd};
 $c->{-cmd} =!$c->{-cmg}? 'frmCall' 
			: $c->{-cmg} eq 'recList' ? 'recList' : 'recForm'
		if !$c->{-cmd};
 $c->{-cmg} =$c->{-cmd} eq 'recForm' ? 'recList' : $c->{-cmd}
		if !$c->{-cmg};

 map {$c->{$_} =datastr($s, $c->{$_})
	} grep {$c->{$_}} qw(-key -qkey);
 $c->{-key} =$s->rmlKey($c, $s->{-pdta})
		if $c->{-key} && !ref($c->{-key}) && $s->{-idsplit};
 $c->{-form}=$c->{-table} 
		if !$c->{-form} && $c->{-table};

 if	($c->{-cmd} eq 'frmCall') {
	my $frm =($c->{-frmName1} ||$c->{-frmName} ||$c->{-form} ||'default');
	$c->{-cmd}  =$c->{-cmg} =($frm =~/[+]+\s*$/
				? 'recNew'
				: $frm =~/[&.]+\s*$/
				? 'recForm'
				: 'recList');
	$frm =($frm=~/^(.+)(?:\s*[+&.]+\s*)$/ ? $1 : $frm);
	map {delete $c->{$_}} qw (-qkey -qwhere -qorder)
			if $frm ne ($c->{-form}||'');
	$c->{-backc} =0 if $frm ne ($c->{-form}||'');
	$c->{-form}  =$frm;
 }

 if	($c->{-cmd} eq 'recNew') {
	$c->{-edit} =1;
 }
 elsif	($c->{-cmd} eq 'recEdit') {
	$c->{-edit} =1;
	$c->{-cmd}  ='recRead'
 }
 elsif	($c->{-cmd} eq 'recPrint') {
	$c->{-print} =1;
	$c->{-cmd}  ='recRead'
 }
 elsif	($c->{-cmd} eq 'recXML') {
	$c->{-xml} =1;
	$c->{-cmd}  =$c->{-cmg} ||'recRead'
 }
 elsif	($c->{-cmd} !~/^(recIns|recUpd|recForm)/) {
	$c->{-edit} =undef
 }

 if	($c->{-cmd} =~/recList/ and $c->{-cmg} =~/recQBF/) {
	$c->{-qkey} =$s->cgiQKey($c->{-form}, undef, $s->{-pdta});
	$c->{-qkey} =undef if !%{$c->{-qkey}};
 }
 elsif	($c->{-cmd} =~/recQBF/ && $c->{-cmg} =~/recList/) {
	$c->{-edit} =1;
        $s->{-pdta} ={};
 	map {$s->{-pdta}->{$_} =$c->{-qkey}->{$_}
		} grep { defined($c->{-qkey}->{$_}) && $c->{-qkey}->{$_} ne ''
			} keys %{$c->{-qkey}} if $c->{-qkey};
	$c->{-qlist}=$c->{-form};
	$c->{-backc}=0;
 }
 $c->{-backc} =(    ($c->{-cmd} eq 'recForm')
		||  ($c->{-cmd} eq 'recIns')
		|| (($c->{-cmd} eq 'recRead') || ($c->{-cmg} eq 'recRead'))
		|| (($c->{-cmd} eq 'recList') || ($c->{-cmg} eq 'recList'))
		? ($c->{-backc}||0) +1
		: 1);
 $c->{-cmh} =$c->{-cmg};		# history general command
 $c->{-cmg} =$s->cgiHook('cmgNext');	# actual  general command
 $s
}


sub cgiHook {	# HTML generation hook condition
 $_[0]->cgiParse() if !$_[0]->{-pcmd}->{-cmd};
 my $c =$_[0]->{-pcmd};
 return($c->{-cmd}) if !$_[1];
   ($_[1] eq $c->{-cmd})		# current operation
 ? $c->{-cmd}
 : ($_[1] eq 'recOp')			# record operation (exept 'recList')
	&& ($c->{-cmd} =~/^rec(New|Form|Read|Edit|Ins|Upd|Del)/)
 ? $c->{-cmd}
 : ($_[1] eq 'appOp')			# application operation ???
	&& ($c->{-cmd} =~/^app/)
 ? $c->{-cmd}
 : ($_[1] eq 'cmgNext')			# next global command to output as hidden
 ? (      $c->{-cmd} eq 'recForm' 
	? $c->{-cmg}
	: (grep {$c->{-cmd} eq $_} qw(recIns recUpd))
	? 'recRead'
	: $c->{-cmd} eq 'recDel'
	? $c->{-cmd}
	: $c->{-cmd})
 : ($_[1] eq 'recMenu')			# generate HTML above form or list ???
	&&($c->{-cmd} !~/app|Help/)
 ? $c->{-cmd}
 : ($_[1] =~/^recForm/)			# generate HTML form of record
	&&($c->{-cmd} !~/app|Help/)
	&&( $_[1] !~/^recForm([RWDQL]+)/
	 ||($_[1] =~/[WR]/ && $c->{-cmg} =~/^rec(Form|Read)/)
	 ||($_[1] =~/[W]/  && $c->{-cmg} =~/^rec(New|Form|Read|Ins|Upd)/)
	 ||($_[1] =~/[D]/  && $c->{-cmg} =~/^rec(Del)/)
	 ||($_[1] =~/[Q]/  && $c->{-cmg} eq 'recQBF')
	 ||($_[1] =~/[L]/  && $c->{-cmg} eq 'recList')
	  )
 ? $c->{-cmd}
 : ($_[1] eq 'recList')			# generate HTML list of records
	&& ($c->{-cmd} eq 'recList')
 ? $c->{-cmd}
 : ($_[1] eq 'recCommit')		# commit database operation
	&& ($c->{-cmd} =~/^rec(New|Form|Read|Ins|Upd|Del|List)/)
 ? $c->{-cmd}
 : ''
}


sub urlAuth {	# Login URL
 my $s =$_[0];
 my $u =$s->{-login};
 if ($u =~/\/$/) {
	my $u0=$u;
	my $u1=$s->cgi->self_url;	#url(-absolute=>1);
	   $u1=($u1=~/^\w+:\/\/[^\/]+(.+)/ ? $1 : $u1);
	my $i;
	while (($i =index($u0, '/')) >=0 and substr($u0,0,$i) eq substr($u1,0,$i)) {
		$u0 =substr($u0, $i+1); $u1 =substr($u1, $i+1);
	}
	$u .=$u1
 }
 $u
}


sub psParse {	# PerlScript Parse Source
 my $s  =shift;	# (?options, perl script source, base URL)
 my $opt=substr($_[0],0,1) eq '-' ? shift : '-';
 my $i  =$_[0];	# input source
 my $b  =$_[1];	# base URL
 my $o  ='';	# output source
 my ($ol,$or) =('','');
 my ($ts,$tl,$ta,$tc) =('','','','');
 if ($i =~/<(!DOCTYPE|html|head)/i && $`) {
     $i ='<' .$1 .$'
 }
 if ($b && $i =~m{(<body[^>]*>)}i) {
     my ($i0,$i1) =($` .$1 ,$');
     $i =$i0 .('<base href="'. $s->urlEscape($b) .'/" />') .$i1
 }
 if ($opt =~/e/i && $i =~m{<body[^>]*>}i) {	# '-e'mbeddable html
    $i =$';
    $i =$` if $i =~m{</body>}i
 }
 while ($i) {
    if (not $i =~m{<(\%@|\%|SCRIPT) *(Language *= *|)* *(PerlScript|Perl|)* *(RUNAT *= *Server|)*[ >]*}i) {
       $ol =$i; $i ='';
       $ts ='';
    }
    elsif (($2 && !$3) || (!$3 && $tl eq '1')) {
       $ol =$` .$&;
       $i  =$';
       $tl =1;
       $tc =$ts ='';
    }
    elsif ($1) {
       $ol =$`; $i =$';
       $ts =uc($1||''); $tl =($2 && $3)||''; $ta=$4||'';
       if ($i =~m{ *(\%>|</SCRIPT>)}i) {$tc =$`; $i =$'}
       else                            {$tc =''}
    }
    else {
       $ol =$i; $i ='';
    }
    $ol =~s/(["\$\@%\\])/\\$1/g;
    $ol =~s/[\n]/\\n");\n\$_[0]->output("/g;
    $o .= "\$_[0]->output(\"$ol\\n\");\n";
    next if !$ts || !$tc || $ts eq '%@';
    $tc =~s/\&lt;?/</g;
    $tc =~s/\&gt;?/>/g;
    $tc =~s/\&amp;?/\&/g;
    $tc =~s/\&quot;?/"/g;
    if    ($ts eq '%')      { $o .= "\$_[0]->output($tc);\n" }
    elsif ($ts eq 'SCRIPT') { $o .= $tc .";\n"}
 }
 $o;
}


sub psEval {	# Evaluate perl script file
 my $s =shift;	# (?options, filename, ?base URL,...)
 my $o =substr($_[0],0,1) eq '-' ? shift : '-';
 my $f =shift;		# filename
 my $u =shift;		# base URL
 my $c =undef;		# code
 if ($f !~/^(\/|\w:[\\\/])/ && !-e $f) {
	$f =$s->{-path} .'/psp/' .$f;
	$u =$s->{-url}  if !$u;
 }
 $s->hfNew($f)->read($c, -s $f)->close();
 $s->output($s->{-c}->{-httpheader} =$s->cgi->header(
		  -charset => $s->{-charset}, -expires => 'now'
		, ref($s->{-httpheader})
		? %{$s->{-httpheader}}
		: ()))
          if $o !~/e/;  # '-e'mbeddable html
 local $SELF =$s;
 $c =eval('sub{' .$s->psParse($o, $c, $u, @_) .'}');
 eval{&$c($s, $o, $f, @_)};
 return(&{$s->{-die} }("psEval($o, $f)->$@") && undef) if $@;
 $s
}


sub cgiAction {	# cgiRun Action Executor incapsulated
		# self, obj name, ?obj meta, ?command, ?data
 my ($s, $on, $om, $oc, $od) =@_;
    $om =$s->{-form}->{$on}||$s->mdeTable($on) if !$om;
    $oc =$s->{-pcmd} if !$oc;
    $od =$s->{-pdta} if !$od;
 my $oa =$s->{-pcmd}->{-cmd};
 my $og =$oc->{-cmg};
 my $ot =$oc->{-table};
 if	($ot && $oa =~/^rec/) {
	if	($oa =~/^recList/) {
		$s->{-pout} =$s->cgiQuery($on, $om)
	}
	elsif	($oa =~/^recQBF/ ||$og =~/^rec(List|QBF)/) {
		$s->{-pout} ={%{$od}}
	}
	elsif	($oa =~/^rec(Read)/) {
		$s->{-pout} =$s->recRead(-table=>$ot
				, ref($om->{-recRead}) eq 'HASH' ? %{$om->{-recRead}} : ()
				, map {($_=>$oc->{$_})
				} grep {defined($oc->{$_}) 
					&& $oc->{$_} ne ''
					}  qw(-key -form));
	}
	else {
		$s->{-pout} =$s->$oa(-data=>$s->cgiDBData($on, $om, $od)
				, -table=>$ot
				, map {($_=>$oc->{$_})
				} grep {defined($oc->{$_}) 
					&& $oc->{$_} ne ''
					}  qw(-key -form));
	}
	$oc->{-key} =$s->recWKey($ot, $s->{-pout})
		if $oa =~/^rec(Read|Ins|Upd)/
		&& $oc->{-edit};
	$s->{-pout} =$s->recRead(-table=>$ot
			, %{$om->{-recRead}}
			, -key=>$oc->{-key})
		if ref($om->{-recRead}) eq 'HASH'
		&& $oa =~/^rec(Ins|Upd)/;
 }
 elsif	($oa =~/^(recForm)/) {
	# nothing needed
 }
 else	{
	return(&{$s->{-die}}($s->lng(0,'cgiRun') .": Action '$oa\@$og' not found") && undef)
 }
 $s->{-pout}
}


sub htmlStart {	# HTTP/HTML/Form headers
 my ($s)=@_;

 my $r	=join(""
	, $s->{-c}->{-httpheader} =$s->cgi->header(
		-charset => $s->{-charset}, -expires => 'now'
		, ref($s->{-httpheader}) 
		? %{$s->{-httpheader}} 
		: ()
		, $s->{-pcmd}->{-xml}
		? (-type => 'text/xml')
		: ()
		)
	, $s->{-c}->{-htmlstart}  =
		  $s->{-pcmd}->{-xml}
		? (ref($s->{-xmlstart})
			? $s->xmlsTag($s->{-xmlstart})
			: ($s->{-xmlstart} ||'<?xml version="1.0" ?>')
				# encoding="' .$s->{-charset}
				# <?xml:stylesheet href="" type="text/css" ?>
		  )
		: $s->cgi->start_html(
			 -head	=> '<meta http-equiv="Content-Type" content="text/html; charset=' .$s->{-charset} .'">'
			,-lang	=> $s->{-lang}
			,-title	=> $s->{-title} ||$s->cgi->server_name()
			,-class	=> (	  $s->cgiHook('recOp')
					? '_Form'
					: $s->cgiHook('recFormQ')
					? '_Form _QBF'
					: $s->cgiHook('recHelp')
					? '_Form _Help'
					: '_Form _List')
				   .' ' .($s->{-pcmd}->{-form}||'default')
			,ref($s->{-htmlstart}) 
			? %{$s->{-htmlstart}} 
			: ())
	, "\n"
	, $s->{-pcmd}->{-xml}
		? $s->xmlsTag($s->{-pcmd}->{-form}||'default'
			, (map { defined($s->{-pcmd}->{$_}) && ($s->{-pcmd}->{$_} ne '')
				? ((substr($_,0,1) eq '-' ? substr($_,1) : $_)
				 ,$s->{-pcmd}->{$_})
				: ()
				} sort keys %{$s->{-pcmd}})
			, 'xmlns'=>$s->cgi->url
			, '0')
		: $s->cgi()->start_multipart_form()) ."\n";
 eval{warningsToBrowser(1)} if *warningsToBrowser;
 $r;
}


sub htmlEnd {	# End of HTML/HTTP output
 my ($s) =@_;
 if ($s->{-pcmd}->{-xml}) {		
	$s->output("\n</" .$s->xmlTagEscape($s->{-pcmd}->{-form}||'default') .">\n")
 }
 else {
	$s->output($s->cgi()->endform(), $s->cgi()->end_html())
 }
}


sub htmlHidden {# Common hidden fields
 my ($s, $on) =@_;
 return('') if $s->{-pcmd}->{-xml} ||$s->{-pcmd}->{-print};
 join("\n"
	,'<input type="hidden" name="_form" value="' .$s->htmlEscape($on) .'" />'
	,'<input type="hidden" name="_cmd"  value="" />'
	,'<input type="hidden" name="_cmg"  value="' .$s->htmlEscape($s->{-pcmd}->{-cmg}) .'" />'
	, map { '<input type="hidden" name="_' .$_ .'" value="'
		.$s->htmlEscape(!defined($s->{-pcmd}->{"-$_"})
			? ''
			: ref($s->{-pcmd}->{"-$_"})
			? strdata($s, $s->{-pcmd}->{"-$_"})
			: $s->{-pcmd}->{"-$_"})
		.'" />'
		} (qw(edit backc key)
		, $s->{-pcmd}->{-cmg} ne 'recQBF'
		? qw(qkey qwhere qurole quname qversion qorder qlimit)
		: qw(qlist)	)
	) ."\n"
}


sub htmlMenu {	# Screen menu bar
 my ($s) =@_;
 return('') if $s->{-pcmd}->{-xml} ||$s->{-pcmd}->{-print};
 my $c =$s->{-pcmd};
 my $a =$c->{-cmd};
 my $g =$c->{-cmg};
 my $e =$c->{-edit};
 my $d =$s->{-pdta};
 my $n =$d->{-new} ||($c->{-cmg} eq 'recNew');
 my @r =();
 if	(1) {				# 'back' js button
	push @r, htmlMB($s, 'back', $s->cgi->url, ($c->{-backc}||1));
 }
 if	($s->{-logo}) {			# Logotype
	push @r, htmlMB($s, 'logo');
 }
 if	($s->uguest()
	&& $s->{-login}) {		# Login
	push @r,htmlMB($s, 'login', $s->urlAuth());
 }
 if	($g eq 'recList') {		# View menu items
	$s->htmlMChs();
      # push @r, htmlMB($s, 'recForm');
	push @r, htmlML($s, 'frmName',  $s->{-menuchs})	if $s->{-menuchs};
	push @r, htmlML($s, 'frmName1', $s->{-menuchs1})if $s->{-menuchs1};
	push @r, htmlMB($s,  htmlField($s, '_qftext', lng($s,1,'-qftext'), {-asize=>5}, $s->{-pcmd}->{-qftext}))
							if $s->{-menuchs};
	push @r, htmlMB($s, 'frmCall')			if $s->{-menuchs};
	push @r, htmlMB($s, 'recXML');
	push @r, htmlMB($s, 'recQBF');
 }
 elsif	($g eq 'recQBF') {		# QBF menu items
	push @r, htmlMB($s, 'recForm');
	push @r, htmlMB($s, 'recList');
 }
 elsif	($g eq 'recDel') {		# Deleted record menu items
 }
 elsif	($s->cgiHook('recOp')) {	# Record menu items
	my $ea	=(!$s->{-rac} ||$s->{-pout}->{-editable}) &&!$s->uguest;
	my @rk	=('','_form'=>$_[0]->{-pcmd}->{-form}, '_cmd'=>'recRead', '_key'=>strdata($_[0], $_[0]->{-pcmd}->{-key}));
	push @r, htmlMB($s, 'recRead',	[@rk, '_cmd'=>'recRead'])
					if !$n;
	push @r, htmlMB($s, 'recPrint',	[@rk, '_cmd'=>'recPrint'])
					if !$n && !$e;
	push @r, htmlMB($s, 'recXML',	[@rk, '_cmd'=>'recXML','_cmg'=>'recRead'])
					if !$n && !$e;
	push @r, htmlMB($s, 'recEdit',	[@rk, '_cmd'=>'recEdit'])
					if !$n && !$e && $ea;
	push @r, htmlMB($s, 'recForm')	if $e;
	push @r, htmlMB($s, 'recUpd')	if $e && !$n;
	push @r, htmlMB($s, 'recIns')	if $e;
	push @r, htmlMB($s, 'recDel')	if !$n && $ea;
	push @r, htmlMB($s, 'recNew')	if !$n && $ea;
 }
 if (1) {				# Help button
 }

 my $mi	='[\'<i>'	.htmlEscape($s,lng($s, 0, $c->{-cmd}))
	.'\'@\''	.htmlEscape($s,lng($s, 0, $c->{-cmg}))
	.'\',  '	.htmlEscape($s, $s->user()) .'</i>]';
 my $mh =htmlEscape($s,    ($s->{-form}->{$c->{-form}} ? $s->{-form}->{$c->{-form}}->{-cmt} ||$s->{-form}->{$c->{-form}}->{-lbl} : '')
			|| ($s->{-table}->{$c->{-form}} ? $s->{-table}->{$c->{-form}}->{-cmt} ||$s->{-table}->{$c->{-form}}->{-lbl} : '')
			|| ($s->{-title} ||$s->cgi->server_name()) .' - ' .($c->{-form} ||''));
 my $mc =$g ne 'recList'
	? ''
	: join("; "
	, grep {$_
		} 
		  htmlEscape($s, $c->{-qkey}
				? join(', ', map { $_ .' ? ' .strquot($s,$c->{-qkey}->{$_})
					} sort keys %{$c->{-qkey}})
				: '')
		, htmlEscape($s, $c->{-qwhere})
		, htmlEscape($s, $c->{-qurole}	? lng($s, 0, '-qurole')   .' ' .$c->{-qurole} : '')
		, htmlEscape($s, $c->{-quname}	? lng($s, 0, '-quname')   .' ' .$c->{-quname} : '')
		, htmlEscape($s, $c->{-qftext}	? lng($s, 0, '-qftext')   .' ' .$c->{-qftext} : '')
		, htmlEscape($s, $c->{-qversion}? lng($s, 0, '-qversion') .' ' .$c->{-qversion} : '')
		, htmlEscape($s, $c->{-qorder}	? lng($s, 0, '-qorder')	  .' ' .$c->{-qorder} : '')
	);

 !$s->{-icons}
 ?  "\n<span class=\"_MenuArea\">" .join("\n", @r, $mi, '<br />', $mh, '<br />', $mc ? ($mc, '<br />') : ()) ."</span>\n\n"
 : ("\n<table class=\"_MenuArea\" cellpadding=0><tr>\n"
	.join("\n", @r)
	."\n" .'<td class="_MenuCell" valign="middle"><nobr>'. $mi .'</nobr></td></tr>'
	."\n" .'<tr><th class="_MenuHeader" align="left" valign="top" colspan=20>' .$mh .'</th></tr>'
	.(!$mc 	? ''
		: "\n" .'<tr><td class="_MenuComment" align="left" valign="top" colspan=20>' .$mc .'</td></tr>')
	."\n</table>\n\n")
}


sub htmlMB {	# CGI menu bar button
		# self, command, url, back|
 my $td0='<td class="_MenuButton" valign="middle" style="border-width: thin; border-style: outset; background-color: buttonface;" ';
 my $tdb=' onmousedown="if(window.event.button==1){this.style.borderStyle=&quot;inset&quot;}" onmouseup="this.style.borderStyle=&quot;outset&quot;" onmouseout="this.style.borderStyle=&quot;outset&quot;" ';
  # $tdb='' if ($ENV{HTTP_USER_AGENT}||'') !~/MSIE/;

 if (!$_[0]->{-icons}) {
	if ($_[1] =~/^</) {
		$_[1]
	}
	elsif ($_[1] eq 'logo') {
		ref($_[0]->{-logo}) eq 'CODE' 
		? &{$_[0]->{-logo}}(@_) 
		: $_[0]->{-logo}
	}
	elsif ($_[1] eq 'login') {
		$_[1]
	}
	elsif ($_[1] eq 'back') {
		 '<input type="submit" class="_MenuButton" name="_' .$_[1] .'" '
		.' value="' .htmlEscape($_[0],lng($_[0], 0, $_[1])) .'" '
		.' onclick="{'
		.(!$_[3] ||$_[3] <2
			? 'window.history.back()'
			: 'window.history.go(-' .($_[3]-1) .'); window.history.back()')
		.'; return(false)}" '
		.' title="' .htmlEscape($_[0],lng($_[0], 1, $_[1])) .'" />'
	}
	else {
		 '<input type="submit" class="_MenuButton" name="_' .$_[1] .'" '
		.' value="' .htmlEscape($_[0],lng($_[0], 0, $_[1])) .'" '
		.' title="' .htmlEscape($_[0],lng($_[0], 1, $_[1])) .'" />'
	}
 }
 elsif ($_[1] =~/^</) {
	$td0 ."><nobr>\n" .$_[1] ."\n</nobr></td>"
 }
 elsif ($_[1] eq 'logo') {
	$td0 ."><nobr>\n" 
	.(ref($_[0]->{-logo}) eq 'CODE' 
		? &{$_[0]->{-logo}}(@_) 
		: $_[0]->{-logo}) ."\n</nobr></td>"
 }
 elsif ($_[1] eq 'login') {
	my $jc =' onclick="{window.location.replace(&quot;'
		.htmlEscape($_[0], $_[2])
		.'&quot;); return(false)}" ';
	$td0 .($tdb ? $tdb .$jc : '') ."><nobr>\n"
	.'<a href="' .$_[2] .'" '
	.' title="' .htmlEscape($_[0], lng($_[0], 1, 'login')) .'" '
	.' style="color: black;" '
	.' ><img src="' .$_[0]->{-icons} .'/' .$IMG->{'login'} .'" border=0  align="bottom" height="22" />'
	.'<font size=-1>' .htmlEscape($_[0], lng($_[0], 0, 'login')) ."</font></a>\n</nobr></td>"
 }
 elsif ($_[1] eq 'back') {
	my $jc =' onclick="{'
		.(!$_[3] ||$_[3] <2
			? 'window.history.back()'
			:('window.history.go(-' .($_[3]-1) 
				.'); window.history.back()'))
		.'; return(false)}" ';
	$td0 .($tdb ? $tdb .$jc : '') ."><nobr>\n"
	.'<a href="' .($_[2]||$_[0]->cgi->url) .'"' 
	.($tdb ? '' : $jc)
	.' title="' .htmlEscape($_[0], lng($_[0], 1, 'back', ($_[3]||1))) .'"'
	.' ><img src="' .$_[0]->{-icons} .'/' .$IMG->{'back'} .'" border=0 align="bottom" height="22" /></a>' ."\n</nobr></td>"
 }
 else {
	my $jc =' onclick="{_cmd.value=&quot;' .$_[1] .'&quot;; submit(); return(false)}" ';
	$td0 .($tdb ? $tdb .$jc : '') ."><nobr>\n"
	.'<input type="image" name="_' .$_[1] .'" '
	.' src="' .$_[0]->{-icons} .'/' .($IMG->{$_[1]}||'none') .'" '
	.' align="bottom" title="' .htmlEscape($_[0],lng($_[0], 1, $_[1])) .'" />'
	.'<a href="' .urlCat($_[0], !$_[2] ? ('', '_form'=>$_[0]->{-pcmd}->{-form},'_cmd'=>$_[1]) : ref($_[2]) ? @{$_[2]} : $_[2]) .'"'
	.' style="color: black;"' #{text-decoration:none;color:black}
	.($tdb ? '' : $jc)
	.' title="' .htmlEscape($_[0],lng($_[0], 1, $_[1])) .'">'
	.'<font size=-1>' .htmlEscape($_[0],lng($_[0], 0, $_[1]))
	."</font></a>\n</nobr></td>"
 }
}


sub htmlML {	# CGI menu bar list
 my $i =$_[0]->cgi->param('_' .$_[1]) ||$_[0]->{-pcmd}->{-form} ||'';
 ($_[0]->{-icons} ? '<td class="_MenuButton" valign="middle" style="border-width: thin; border-style: outset; background-color: buttonface;" >' : '')
 .'<select name="_' .$_[1] 
 .'" onchange="{_cmd.value=&quot;frmCall&quot;; '
 .(($_[1] eq 'frmName') && $_[0]->{-menuchs1} ? '_frmName1.value=&quot;&quot;; ' : '')
 .'submit(); return(false);}">'
 ."\n\t"
 .join("\n\t"
	, map { my ($n, $v) =!ref($_) ? ($_, $_) : ref($_) eq 'ARRAY' ? @$_ : ($_->{-val}, $_->{-lbl});
		'<option ' .($i && ($n eq $i) ? 'selected' : '') 
		.(!$n ? ' class="_MenuSeparator"' : '')
		.' value="' 
		.htmlEscape($_[0], $n)
		.'">' 
		.htmlEscape($_[0], $v)
		.'</option>'
		} @{$_[2]}
	)
 ."\n</select>"
 .($_[0]->{-icons} ? '</td>' : '')
}


sub htmlMChs {	# Adjust CGI forms list
 if (!$_[0]->{-menuchs}) {
 $_[0]->{-menuchs} =[];
 if	($_[0]->{-form}) {
	push @{$_[0]->{-menuchs}},
		map {[$_, ($_[0]->{-form}->{$_}->{-lbl}||$_)]
			} grep {$_ ne 'default'} keys %{$_[0]->{-form}}
 }
 if	($_[0]->{-table}) {
	push @{$_[0]->{-menuchs}},
	map {[$_, ($_[0]->{-table}->{$_}->{-lbl}||$_)]
		} keys %{$_[0]->{-table}}
 }
 @{$_[0]->{-menuchs}} =sort {lc(ref($a) && $a->[1] || $a) cmp lc(ref($b) && $b->[1] || $b)} @{$_[0]->{-menuchs}};
 if ($_[0]->{-menuchs}) {
	my @a =( ['','---' .lng($_[0], 0, 'Create') .'---']
		, map {[$_->[0] .'+', $_->[1] .' ++']
			} grep { my $m;
				  ($m =$_[0]->{-form}->{$_->[0]})
				?  $m->{-field}
				: ($m =$_[0]->{-table}->{$_->[0]})
				? !$m->{-ixcnd}
				: 0
				} @{$_[0]->{-menuchs}}
		);
	if (@{$_[0]->{-menuchs}} <6)	{push @{$_[0]->{-menuchs}}, @a}
	else				{$_[0]->{-menuchs1} =[@a]}
 }}
 if ($_[0]->{-menuchs1} && $_[0]->{-menuchs1}->[0]->[0]) {
	unshift @{$_[0]->{-menuchs1}}, ['', '---' .lng($_[0], 0, 'Create') .'---']
 }
 $_[0]->{-menuchs}
}


sub cgiDBData {	# Database data fields/values
		# self, form, meta, value hash
 my ($s, $n, $m, $v) =@_;
     $m =$s->{-form}->{$n}||$s->{-table}->{$n} if !$m;
 my  $mt=$m->{-field}||($m->{-table} && $s->{-table}->{$m->{-table}}->{-field})||[];
 my  $r ={};
 foreach my $f (@$mt) {
	next if ref($f) ne 'HASH';
	$r->{$f->{-fld}} =!defined($v->{$f->{-fld}})
			? $v->{$f->{-fld}}
			: $f->{-null} && $v->{$f->{-fld}} eq $f->{-null}
			? undef
			: $v->{$f->{-fld}}
		if exists ($v->{$f->{-fld}})
		&& (!$f->{-flg}
		||   $f->{-flg} =~/[au]/);	# 'a'll, 'u'pdate
 }
 %$r ? $r : undef
}


sub cgiForm {	# Print CGI screen form
		# self, form name, form meta, command, data
 my ($s, $n, $m, $c, $d) =@_;
    $m =$s->{-form}->{$n}||$s->mdeTable($n) if !$m;
    $c =$s->{-pcmd} if !$c;
    $d =$s->{-pout} if !$d;

 return($s) if $c->{-cmg} eq 'recDel';

 my $qm=$c->{-cmg} eq 'recQBF';
 my $em=$c->{-edit} || $qm;
 my $mt=$m->{-table} ? $s->mdeTable($m->{-table}) : $m;
 my $rskip =$c->{-xml} ? undef : 1;
 $s->output('<table>'
	,"\n<tr>\n"
	, $m->{-fwidth}
	? '<th colspan=20><nobr>' 
		.('&nbsp;' x $m->{-fwidth}) ."</nobr></th></tr>\n<tr>\n"
	: ''
	) if !$c->{-xml};

 # form additions	- using sub{} fields
 # file attachments	- using 'ddfRFD' / 'htmlRFD'
 # versions		- using sub{} fields with queries
 # embedded views	- using sub{} fields with queries

 foreach my $f (@{$m->{-field} 
		||$m->{-query}->{-data} 
		||($m->{-table} && $s->mdeTable($m->{-table})->{-field})}) {
	if	($c->{-xml} 
		&& !ref($f))	{
		next
	}
	elsif	($c->{-xml})	{
		if	(ref($f) eq 'CODE')		{next}
		elsif	($f->{-inp}
			&& $f->{-inp}->{-rfd}
			&& $s->{-pout}->{-file})	{
			my $u =$s->rfdPath(-url=>$s->{-pcmd}, $s->{-pout});
			   $u =$s->cgi->url(-base=>1) .$u if $u !~/\/\/\w+:/;
			my $v =join("\n", map { $u .'/' .$_
				} $s->rfdGlobn($s->{-pcmd}, $s->{-pout}));
			$s->output($s->xmlsTag('Attachments',''=>$v),"\n");
			next
		}
		elsif	(!$f->{-fld}
			||!defined($d->{$f->{-fld}})
			||($d->{$f->{-fld}} eq ''))	{next}
		my $v =$d->{$f->{-fld}};
		if	($f->{-htmlopt}
			&& $s-ishtml($v))	{
			$s->output('<',$f->{-fld},'>',$v,'</',$f->{-fld},">\n")
		}
		elsif	($f->{-hrefs}) {
			my $u =$s->rfdPath(-url=>$s->{-pcmd}, $s->{-pdta})||$s->rfdPath(-urf=>$s->{-pcmd}, $s->{-pdta});
			   $u =$s->cgi->url(-base=>1) .$u if $u !~/\/\/\w+:/;
			$v =~s/\b((?:host|urlh):\/\/)/$s->cgi->url(-base=>1) .'\/'/ge;
			$v =~s/\b((?:url|urlr):\/\/)/$s->cgi->url() .'\/'/ge;
			$v =~s/\b((?:fsurl|urlf):\/\/)/$u .'\/'/ge;
			$s->output($s->xmlsTag($f->{-fld}, ''=>$v), "\n")
		}
		else	{
			$s->output($s->xmlsTag($f->{-fld}, ''=>$v), "\n")
		}
		next
	}
	elsif	($f eq '')	{
		$rskip =1 if defined($rskip);
		next
	}
	elsif	($f eq "\t")	{
		next if !defined($rskip);
		$s->output(!$rskip
			? "\n</tr>\n<tr>\n"
			: ''
			, "<td> </td>\n");
		$rskip =1;
		next
	}
	elsif	($f eq "\n")		{
		$s->output(defined($rskip) ? "\n</tr>\n<tr>\n" : "\n<br />\n");
		next
	}
	elsif	($f eq "\f")		{
		$s->output("\n</tr>\n</table>\n");
		$rskip =undef; 
		next 
	}
	elsif	(!$f)			{next}
	elsif	(!ref($f))		{$s->output($f); next}
	elsif	(ref($f) eq 'CODE')	{$s->output(&$f($s,$n,$m,$c,$d)); next}
	else				{}

	local  $_=$d->{$f->{-fld}};
	my $excl =0;
	my $hide = $qm && ($f->{-flg}||'') =~/[aq]/	# 'a'll, 'q'uery
		 ? 0
		 : ((ref($f->{-hide})  eq 'CODE' ? &{$f->{-hide}} ($s,$f,$em,$qm,$_)  : $f->{-hide})
		 || (ref($f->{-hidel}) eq 'CODE' ? &{$f->{-hidel}}($s,$f,$em,$qm,$_) : $f->{-hidel})
		 || ($qm && !$f->{-fld})
		 || ($qm && ($f->{-flg}||'q') !~/[aq]/)
		 || ($qm && $f->{-inp} && ((ref($f->{-inp}) ne 'HASH') || grep {$f->{-inp}->{$_}} qw(-rows -arows -hrefs -rfd))));
	my $edit =!$em
		? $qm
		: ref($f->{-edit})  eq 'CODE'
		? $qm ||&{$f->{-edit}}(@_)
		: exists($f->{-edit})
		? $qm ||$f->{-edit}
		: $f->{-flg}		# 'a'll, 'e'dit', 'q'uery
		? $f->{-flg}=~/[ae]/ ||($qm && $f->{-flg}=~/[q]/)
		: 1;

	my $lbl =$s->htmlEscape($f->{-lbl}||$s->lng(0, $f->{-fld}));
	my $cmt =($f->{-cmt}||$f->{-lbl}||$s->lng(1, $f->{-fld})) .' [' .$f->{-fld} .($f->{-flg} ? ': ' .$f->{-flg} : '') .']';
	my $rid =!$hide && !$excl && !$qm 
		&& $d->{$f->{-fld}}
		&& (($m->{-ridRef} ||$s->{-ridRef})
			&& (grep {$f->{-fld} eq $_} @{$m->{-ridRef}||$s->{-ridRef}})
			|| ($f->{-fld} eq ($m->{-rvcActPtr}||$s->{-rvcActPtr}||'"'))
			|| ($f->{-fld} eq ($m->{-key} && @{$m->{-key}} <2 && $m->{-key}->[0]))
			)
		&& (!$f->{-inp} || !grep {$f->{-inp}->{$_}} qw(-arows -rows -cols -hrefs -htmlopt))
		? '<a href="?_cmd=recRead' 
		  .($d->{$f->{-fld}} !~/\Q$RISM1\E/ ? $HS ."_form=$n" : '')
		  .$HS .'_key=' .$d->{$f->{-fld}} .'">'
		: undef;
	if	($excl||$hide)	{$lbl =' '}
	elsif	(defined($f->{-lblhtml})) {
		my $l =$f->{-lblhtml};
		$l =&$l($s,$f,$em,$qm,$_) if ref($l) eq 'CODE';
		$l =~s/<\s*input[^<>]*>//ig if !$em;
		$l =~s/\$_/$lbl/;
		$lbl =$l
	}
	$lbl	=$rid .$lbl .'</a>'
		if $rid && $em && $edit && $lbl !~/<a\s+href\s*=\s*/i;
	$lbl	=($lbl =~/<t[dh]\b/i ? $lbl : "<th align=\"left\" valign=\"top\">$lbl</th>")
		if !($hide && $f->{-hidel}) && defined($rskip);

	my $wgp =$excl || $hide
		? ''
		: !$edit
		? htmlField($s, '', $cmt, $f->{-inp}, $d->{$f->{-fld}})
		: htmlField($s, $f->{-fld}, $cmt, $f->{-inp}, $d->{$f->{-fld}});
	if (!$hide && defined($f->{-inphtml})) {
		my $wgh	=$f->{-inphtml};
		$wgh	=&$wgh($s,$f,$em,$qm,$_) if ref($wgh) eq 'CODE';
		$wgh	=~s/<\s*input[^<>]*>//ig if !$edit;
		$wgh	=~s/\$_/$wgp/;
		$wgp	=$wgh
	}
	$wgp	=$rid .$wgp .'</a>'
		if $rid && !$edit && $wgp !~/<a\s+href\s*=\s*/i;
	$wgp	='<td valign="top" align="left" '
		.($f->{-colspan} ? ' colspan=' .$f->{-colspan} :'')
		.($f->{-colwidth} && $f->{-colwidth} =~/\D/ ? ' width='   .$f->{-colwidth}   :'')
		.'>' .$wgp .'</td>'
		if $wgp !~/<t[dh]\b/i && defined($rskip) 
		&& !($hide && $f->{-hidel});

	if	(defined($rskip)) {
		if ($f->{-ddlb} && $em) {
			my $wg1;
			($wgp, $wg1) =($1, $2) if $wgp =~/^(.*)(<\/t[dh]>)$/i;
			$s->output(($rskip ? '' : "\n</tr>\n<tr>\n"), $lbl, $wgp);
			$s->cgiDDLB($f, $m);
			$s->output($wg1, "\n");
			$wgp .=$wg1
                }
		else {
			$s->output(($rskip ? '' : "\n</tr>\n<tr>\n"), $lbl, $wgp, "\n");
		}
		$rskip =0
	}
	elsif	(!$hide) {
		if ($f->{-ddlb} && $em) {
			$s->output($lbl, ' ', $wgp);
			$s->cgiDDLB($f, $m);
			$s->output("<br />\n")
		}
		elsif ($wgp ne '')  {
			$s->output($lbl, ' ', $wgp
				, $wgp =~/<(\/p|br\s*\/)>[\s\r\n]*$/i
				? "\n" : "<br />\n")
		}
	}
 }

 if ($qm) {	# Query condition fields
	my $q =$m->{-query} ||{};
	$s->output("<table>\n") if !defined($rskip);
	$rskip =0;
	my $th ='<tr><th align="left" valign="top">';
	my $td ='<td align="left" valign="top" colspan=10>';
	my $de =$s->{-table}->{$m->{-table}||$n};
	   $de =($de && $de->{-dbd})||$s->{-ns}->{-dbd};
	my $qo ={qw (all all eq == ge >= gt > le <= lt <)};
	   $qo ={map {("-a$_", 'asc ' .$qo->{$_}, "-d$_", 'dsc ' .$qo->{$_})} keys %$qo};
	$s->{-pcmd}->{-qkey} =$s->cgiQKey($n,$m,$s->{-pdta});
	$s->output($th, htmlEscape($s, lng($s,0,'-qwhere')), '</th>', $td
		, htmlField($s, '_qwhere', lng($s,1,'-qwhere') .': '
			. ($de eq 'dbm'	? "Perl: {fieldname} (eq|[gl][et]) 'value' and|or {fieldname} <>==value..." 
					: "SQL: fieldname <>= 'value' and|or...")
			, {-arows=>1,-cols=>45}, $s->{-pcmd}->{-qwhere})
		, '<font size="-1" title="additional">'
		, !$q->{-where} 
		? ()
		: ref($q->{-where}) eq 'ARRAY' 
		? $s->htmlEscape(' AND ' .join(' AND ', @{$q->{-where}}))
		: ref($q->{-where})
		? $s->htmlEscape('(' .$q->{-where} .')')
		: $s->htmlEscape(' AND ' .$q->{-where})
		, $q->{-filter}
		? $s->htmlEscape(' FILTER ' .$q->{-filter})
		: ()
		, $m && $m->{-qfilter}
		? $s->htmlEscape(' FILTER ' .$m->{-qfilter})
		: ()
		, "</font></td></tr>\n");
	if ($s->mdeRAC($m)) {
		$s->output($th, htmlEscape($s, lng($s,0,'-qurole')), '</th>', $td
		, htmlField($s, '_qurole', lng($s,1,'-qurole'), {-values=>[qw(author authors actors principals)]}, $s->{-pcmd}->{-qurole})
		, $q->{-urole} 
		? '<font size="-1" title="default">' .$s->htmlEscape('(' .$q->{-urole} .')') .'</font>' 
		: ()
		, htmlField($s, '_quname', lng($s,1,'-quname'), undef, $s->{-pcmd}->{-quname})
		, $q->{-uname} 
		? '<font size="-1" title="default">' .$s->htmlEscape('(' .$q->{-uname} .')') .'</font>'
		: ()
		);
		$s->cgiDDLB({-fld=>'_quname', -ddlb=>sub{$_[0]->uglist({})}});
		$s->output("</td></tr>\n");
	}
	$s->output($th, htmlEscape($s, lng($s,0,'-qftext')), '</th>', $td
		, htmlField($s, '_qftext', lng($s,1,'-qftext'), {-size=>50}, $s->{-pcmd}->{-qftext})
		, $q->{-ftext} 
		? '<font size="-1" title="default">' .$s->htmlEscape('(' .$q->{-ftext} .')') .'</font>'
		: ()
		, "</td></tr>\n");
	$s->output($th, htmlEscape($s, lng($s,0,'-qversion')), '</th>', $td
		, htmlField($s, '_qversion', lng($s,1,'-qversion'), {-values=>['-','+']}, $s->{-pcmd}->{-qversion})
		, '<font size="-1" title="default">('
		, $q->{-version} || '-', ')</font>'
		, "</td></tr>\n");
	$s->output($th, htmlEscape($s, lng($s,0,'-qorder')), '</th>', $td
		, htmlField($s, '_qorder', lng($s,1,'-qorder')
			, {$de eq 'dbm' 
			  ? (-labels=>$qo)
			  :(-asize=>50)}
			, $s->{-pcmd}->{-qorder}||'')
		, '<font size="-1" title="default">'
		, $q->{-order} 
		? $s->htmlEscape('(' .($qo->{$q->{-order}} ||$q->{-order} ||$qo->{$q->{-keyord}} ||$q->{-keyord}) .')')
		: $de eq 'dbm'
		? $s->htmlEscape('(' .($qo->{$KSORD}||$KSORD) .')')
		: ()
		, '</font>'
		, "</td></tr>\n");
	$s->output($th, htmlEscape($s, lng($s,0,'-qlimit')), '</th>', $td
		, htmlField($s, '_qlimit', lng($s,1,'-qlimit')
			, {-values=>[128,256,512,1024,2048,4096]}
			, $s->{-pcmd}->{-qlimit}||'')
		, '<font size="-1" title="default">('
		, $q->{-limit}||$m->{-limit}||$s->{-limit}||$LIMRS
		, ')</font>'
		, "</td></tr>\n");
	$s->output($th, '</th>', $td
		, $s->htmlEscape($s->urlCat($s->cgi->url(-relative=>1)
			, '_cmd'=>'recList', '_form'=>$s->{-pcmd}->{-form}
			, map {("_$_", ref($s->{-pcmd}->{"-$_"}) ? $s->strdata($s->{-pcmd}->{"-$_"}) : $s->{-pcmd}->{"-$_"})
			} qw(qftext qkey qversion qwhere qorder)
		  ))
		, "</td></tr>\n");
 }
 else {		# Read/Edit, should be nothing

 }

 $s->output(defined($rskip) ? "</table>\n" : "\n") if !$c->{-xml};

 $s
}


sub htmlField {	# Generate field widget HTML
		# self, field name, title, meta, value
 my ($s, $n, $t, $m, $v) =@_;
 my $wgp ='';
 $v ='' if !defined($v);
 if	(!$n)	{				# View only
	if	(ref($m) ne 'HASH')	{			# Textfield
		$wgp  =htmlEscape($s, $v) 
	}
	elsif	($m->{-htmlopt} && $s->ishtml($v))	{	# HTML Text
		$wgp  =$v
	}
	elsif	($m->{-hrefs})	{				# Text & Hyperlinks
		$wgp .='<code>' if $v =~/ {2,}/;
		while ($v =~/\b(\w{3,5}:\/\/[^\s\t,()<>\[\]"']+[^\s\t.,;()<>\[\]"'])/) {
			my $r =$1;
			$v    =$';
			my $w =htmlEscape($s, $`); $w =~s/( {2,})/'&nbsp;' x length($1)/ge; $w =~s/\n/<br \/>\n/g; $w =~s/\r//g;
			$wgp .=$w;
			$r    =~s/^(host|urlh):\/\//\//;
			$r    =~s/^(url|urlr):\/\///;
			$r    =~s/^(fsurl|urlf):\/\//($s->rfdPath(-url=>$s->{-pcmd}, $s->{-pdta})||$s->rfdPath(-urf=>$s->{-pcmd}, $s->{-pdta})) .'\/'/e;
			$wgp .="<a href=\"$r\" target =\"_blank\">" .$s->htmlEscape(length($r) >49 ? substr($r,0,47) .'...' : $r) .'</a>';
		}
		$v =htmlEscape($s, $v); $v =~s/( {2,})/'&nbsp;' x length($1)/ge; $v =~s/\n/<br \/>\n/g; $v =~s/\r//g;
		$wgp .=$v;
		$wgp .='</code>' if $wgp =~/^<code>/;
	}
	elsif	(grep {exists($m->{$_})} qw(-arows -rows -cols)) {# Resizeable text
		$v =$s->htmlEscape($v); $v =~s/( {2,})/'&nbsp;' x length($1)/ge; $v =~s/\n/<br \/>\n/g; $v =~s/\r//g;
		$v ="<code>$v</code>" if $v =~/&nbsp;&nbsp/;
		$wgp  =$v;
	}
	elsif	($m->{-labels}) {				# Listbox
		my $l =$m-{-labels};
		$l    =&{$l}($s)	if ref($l) eq 'CODE';
		$v    =$l->{$v}		if defined($l->{$v});
		$wgp  =htmlEscape($s, $v)
	}
	elsif	(ref($m->{-values}) eq 'HASH') {		# Listbox
		$wgp  =htmlEscape($s, exists($m->{-values}->{$v}) ? $m->{-values}->{$v} : $v)
	}
	elsif	($m->{-rfd}) {					# RFD Filebox
		$wgp =$s->htmlRFD()
	}
	else {							# Textfield
		$wgp =htmlEscape($s, $v)
	}
 }
 elsif	(!$m) {					# Default text field
	my $l =defined($v) ? length($v) : 0;
	   $l =$l <20 ? 20 : $l >80 ? 80 : $l;
	$wgp  ='<input type="text" name="' .$n
		.'" title="'	.htmlEscape($s, $t)
		.'" size="'	.$l
		.'" value="'	.htmlEscape($s, $v)
		.'" />'
 }
 elsif (ref($m) eq 'HASH') {
	if	(exists $m->{-arows} 
		|| grep {$m->{$_}} qw(-rows -cols -hrefs)) {	# Textarea
		my $a ={%$m}; delete @$a{-hrefs, -arows};
		my $ar=exists($m->{-arows}) ? $m->{-arows} ||3 : undef;
		if ($ar) {
			$ar =0;
			$a->{-cols} =20 if !$a->{-cols};
			if ($a->{-wrap} && lc($a->{-wrap}) eq 'off') {
				my @a =split /\n/, $v;
				$ar =scalar(@a)
			}
			else {
				foreach my $r (split /\n/, $v) {
					$ar +=1 +(length($r) >$a->{-cols} 
					? int(length($r)/$a->{-cols}) +1 
					:0);
				}
			}
			$a->{-rows} =($m->{-arows} >$ar ? $m->{-arows} : $ar);
			$a->{-rows} =20 if $a->{-rows} >30;
		}
		if (defined($m->{-hrefs})) {
			my $w =$v;
			my @h;
			while ($w =~/\b(\w{3,5}:\/\/[^\s\t,()<>\[\]"']+[^\s\t.,;()<>\[\]"'])/) {
				my $t =$1;
				$w =$';
				$t =~s/^(host|urlh):\/\//\//;
				$t =~s/^(url|urlr):\/\///;
				$t =~s/^(fsurl|urlf):\/\//($s->rfdPath(-url=>$s->{-pcmd}, $s->{-pdta})||$s->rfdPath(-urf=>$s->{-pcmd}, $s->{-pdta})) .'\/'/e;
				push @h, $t;
			}
			$wgp .=join(';&nbsp; '
				, map {$_ =htmlEscape($s, $_);
					"<a href=\"$_\">"
					.(length($_) >49 ? substr($_,0,47) .'...' : $_)
                                        .'</a>'} @h);
			$wgp .='<br />' if $wgp;
		}
		$wgp .=$s->cgi->textarea(%$a,-name=>$n,-title=>$t,-default=>$v);
			# !!! doubt -CONTENTEDITABLE=>'true' (MSHTML - Microsoft HTML Object Library)
		$wgp .="<input type=\"submit\" name=\"${n}__b\" value=\"R\" "
			."title=\"Rich/Text edit: ^Bold, ^Italic, ^Underline, ^Link, Enter/shift-Enter, ^(shift)T ident, ^Z undo, ^Y redo.\nSwitch to 'T'ext before saving!!!\" "
			."style=\"font-style: italic;\" "
			# ; font-weight: bold; font-family: fantasy
		."onclick=\"{if(${n}__b.value=='R') {${n}__b.value='T'; ${n}__r.DocumentHTML=$n.value ? $n.value : ''; ${n}__r.width='100%';\n $n.rows='1'; ${n}__r.height='50%';}\n"
		."else {var r; ${n}__b.value='R'; r=${n}__r.DocumentHTML.match(/&lt;BODY&gt;[\\s]*([\\s\\S]*)[\\s]*&lt;\\/BODY&gt;/); "
		."$n.value=r ? r[1] : ${n}__r.DocumentHTML; ${n}__r.width='1'; ${n}__r.height='1'; $n.rows='6'};\n"
			." return(false)}\" />\n"
			."<object classid=\"clsid:2D360201-FFF5-11d1-8D03-00A0C959BC0A\" id=${n}__r height=0 width=0 name=\"${n}__r\" title=\"DHTML Editing Component\"></object>\n"
			#DHTML Edit Control for IE5, DHTML Editing Component, HTMLRichtextElement:
			#http://msdn.microsoft.com/archive/default.asp?url=/archive/en-us/dnaredcom/html/dhtmledit.asp
			if $m->{-htmlopt} && ($ENV{HTTP_USER_AGENT}||'') =~/MSIE/;
	}
	elsif	(exists $m->{-asize}) {			# Textfield
		my $z =$m->{-asize} ||20; delete $m->{-asize};
		my $l =defined($v) ? length($v) : 0;
		   $l =$l < $z ? $z : $l >80 ? 80 : $l;
		$wgp  =$s->cgi->textfield((map {($_=>$m->{$_})} grep {$_ !~/-(asize)/} keys %$m)
					,-name=>$n
					,-title=>$t
					,-override=>1
					,-default=>$v
					,-size=>$l);
		$m->{-asize} =$z
	}
	elsif	($m->{-values} ||$m->{-labels}) {	# Listbox
		my $tv	=$m->{-values};
		   $tv	=&$tv($s) if ref($tv) eq 'CODE';
		my $tl	=$m->{-labels};
		   $tl	=&$tl($s) if ref($tl) eq 'CODE';
		$tv	=[sort {$tl->{$a} cmp $tl->{$b}} keys %$tl]
		   if !$tv && $tl;
		unshift @$tv, '' if $s->{-pcmd}->{-cmg} eq 'recQBF';
		$wgp	=$s->cgi->popup_menu(%$m,-name=>$n,-title=>$t
			, $tv ? (-values=>$tv) : ()
			, $tl ? (-labels=>$tl) : ()
			,-override=>1,-default=>$v)
	}
	elsif	($m->{-rfd}) {				# RFD Filebox
		$wgp =$s->htmlRFD()
	}
	else {						# Textfield
		$wgp =$s->cgi->textfield(%$m,-name=>$n,-title=>$t,-override=>1,-default=>$v)
	}
 }
 elsif (ref($m) eq 'CODE') {			# Any other...
	$wgp =&$m(@_)
 }
 $wgp
}


sub htmlRFD {	# RFD widget html
 my ($s, $n, $m, $c, $d) =@_;
     $n =$s->{-pcmd}->{-form} if !$n || $n=~/^\d*$/;
     $m =$s->{-form}->{$n}||$s->{-table}->{$n} if !$m;
     $c =$s->{-pcmd} if !$c;
     $d =$s->{-pout} if !$d;
 return('') if !$d->{-file};
 my  $edt=$s->{-pcmd}->{-edit} && rfdEdmd($s, $c, $d);
 my  $pth=$s->rfdPath(-path=>$c, $d);
 my  $urf=$s->rfdPath(-urf=>$c, $d);
 my  $url=$s->rfdPath(-url=>$c, $d);
 my  $fnu='_file_u';
 my  $fnc='_file_c';
 my  $fnf='_file_f';
 my  $fnl='_file_l';
 my  $fno='_file_o';
 my  $r ='';
 if ($edt && $s->cgi->param($fnu)) {	# Upload
	$s->rfaUpload($c, $d, $fnu);
 }
 if ($edt && $urf 			# Close
 &&  $s->cgi->param($fnc)) {
	$s->nfclose($pth, [$s->cgi->param($fnc)])
 }
 if ($edt && $s->cgi->param($fnf)) {	# Delete
	$s->rfaRm($c, $d, [$s->cgi->param($fnl)])
 }

 if ($edt) {				# Edit widget
	my $fo =($s->cgi->param($fno)||$s->cgi->param($fnc))
		&& $s->nfopens($pth,{});
	$r .=$s->cgi->filefield(-name=>$fnu, -title=>$s->htmlEscape($s->lng(1,'Upload')))
	.$s->cgi->submit(-name=>$fnf, -value=>$s->lng(0,'+|-'), -title=>$s->lng(1,'+|-'))
	.(!$fo && $^O eq 'MSWin32'
		? $s->cgi->submit(-name=>$fno, -value=>$s->lng(0,'rfaopen'), -title=>$s->lng(1,'rfaopen'))
		: '')
	.($fo	? $s->cgi->scrolling_list(-name=>$fnc, -override=>1, -multiple=>'true'
			, -title=>$s->lng(1,'rfaopen')
			, -values=>	['---' .$s->lng(0,'Close') .'---'
					,ref($fo) eq 'HASH' ? sort keys %$fo : @$fo]
			, ref($fo) eq 'HASH' ? (-labels=>$fo) : ())
		: '')
	."\n&nbsp;&nbsp;&nbsp;\n"
	.join('; ', 
		map {	my $f =$s->urlEscape($_);
			$s->cgi->a({-href=>"$url/$f", -target=>'_blank'}
			, $s->cgi->checkbox(-name=>$fnl, -value=>$_, -label=>$_, -title=>$s->lng(1,'rfadelm')))
		} $s->rfdGlobn($c, $d))
 }
 else	{				# View widget
	$r .=' '
	.join('; ', 
		map {	my $f =$s->urlEscape($_);
			'<a href="' . "$url/$f" .'" target="_blank" >'
			. $_ .'</a>'
		} $s->rfdGlobn($c, $d))
 }
 $r
}


sub cgiDDLB {	# CGI Drop-down list box
 my ($s, $f) =@_;
 my $d =$f->{-ddlb};
    $d =ref($d) eq 'CODE' ? &$d(@_) : $d;
 my $mv=$f->{-ddlbmult};
 my $tg=$f->{-ddlbtgt} ||$f->{-fld};
 my $nl=$f->{-fld} .'__L';	# List
 my $no=$f->{-fld} .'__O';	# Open	button
 my $nc=$f->{-fld} .'__C';	# Close	button
 my $ne=$f->{-fld} .'__S';	# Set	button

 if	($s->{-pdta}->{$ne}) {		# real assignment in 'cgiParse'
	$s->{-pout}->{$tg} =$s->{-pdta}->{$nl};
 }
 if	(!$s->{-pdta}->{$no}) {		# open button & exit
	$s->output($s->cgi->submit(-name=>$no, -value=>$s->lng(0,'ddlbopen'), -title=>$s->lng(1,'ddlbopen')));
	return('');
 }
 $s->output($s->cgi->submit(-name=>$nc, -value=>$s->lng(0,'ddlbclose'), -title=>$s->lng(1,'ddlbclose')), "<br />\n");
 my $sl='<select name="' .$nl . '" size="10" >';
 my $fmt =sub{length($_[0]) >60 ? substr($_[0],0,60) .'...' : $_[0]};
 if	(ref($d) eq 'ARRAY') {
	$s->output($sl, "\n");
	foreach my $e (@$d) {
		$s->output(
		 '<option value="' .htmlEscape($s, (ref($e) ? $e->[0] : $e)) .'">'
		,htmlEscape($s, &$fmt(ref($e) ? join(' - ', @$e) : $e))
		,"</option>\n")
	}
	$s->output("</select>");
 }
 elsif	(ref($d) eq 'HASH') {
	$s->output($sl, "\n");
	foreach my $e (sort {lc(ref($d->{$a}) ? join(' - ',@{$d->{$a}}) : $d->{$a}) 
			cmp  lc(ref($d->{$b}) ? join(' - ',@{$d->{$b}}) : $d->{$b})} 
			keys %$d) {
		$s->output(
		 '<option value="' .htmlEscape($s, (ref($e) ? $e->[0] : $e)) .'">'
		,htmlEscape($s, &$fmt(ref($d->{$e}) ? join(' - ', @{$d->{$e}}) : $d->{$e}))
		,"</option>\n")
	}
	$s->output("</select>");
 }
 else {
	$s->cgiList('', {}, {}, $d, $sl);
 }
 $s->output("<br />\n");
 if (ref($tg)) {
	foreach my $b (ref($tg) ? @$tg : $tg) {
		my ($n, $l, $m) =ref($b) ? @$b : ($b,$b,$b =~/[+,;]/);
		   $n =$f->{-fld} if !defined($n);
		   $l =($m ? '<+' : '<') .$s->lng(0, $n) if !defined($l);
		my $f =($n =~/^[<+-]*(.+)/ ? $1 : $n);
		   $m =',' if $m && $m =~/^\d*$/;
		$s->output($s->cgi->button(
		  -value=>$l
		, -title=>$s->lng(1,'ddlbsubmit')
		, -onClick=>"{var fs =window.document.forms[0].$nl;\n"
			."var ft =window.document.forms[0].$f;\n"
			."var i  =fs.selectedIndex;\n"
			.($s->cgi->user_agent('MSIE')
			?(!$m	? "ft.value =(fs.options.item(i).value ==\"\" ? fs.options.item(i).text : fs.options.item(i).value);}\n"
				: "ft.value =(ft.value ==\"\" ? \"\" : (ft.value +\"$m\")) +(fs.options.item(i).value ==\"\" ? fs.options.item(i).text : fs.options.item(i).value);}\n")
			:(!$m	? "ft.value =fs[i].value;}\n"
				: "ft.value =(ft.value ==\"\" ? \"\" : (ft.value +\"$m\")) +fs[i].value;}\n")
			)
		))
	}
 }
 else {
	$s->output($s->cgi->submit(-name=>$ne, -value=>$s->lng(0,'ddlbsubmit'), -title=>$s->lng(1,'ddlbsubmit')));
 }
 $s->output($s->cgi->button(-value=>$s->lng(0,'ddlbfind'), -title=>$s->lng(1,'ddlbfind')
         ,-onClick=>
            "{var k;\n"
           ."var l=window.document.forms[0].$nl;\n"
           ."k=prompt('Enter search string',''); if(!k){return(false)};\n"
           ."k=k.toLowerCase();\n"
           ."for (var i=0; i <l.length; ++i) {"
           ."if (l.options.item(i).value.toLowerCase().indexOf(k)==0){"
           ."l.selectedIndex =i; return(false); break}}}\n"
         ));
 $s->output($s->cgi->submit(-name=>$nc, -value=>$s->lng(0,'ddlbclose'), -title=>$s->lng(1,'ddlbclose')),"\n");
}


sub cgiQKey {	# Make Query Key from fields filled
 my ($s, $n, $m, $v) =@_;
     $m =$s->{-form}->{$n}||$s->{-table}->{$n} if !$m;
 my $k ={};
 if	($m->{-query} && $m->{-query}->{-data}) {
	map {$k->{$_} =$v->{$_}
		} grep { defined($v->{$_}) && $v->{$_} ne ''
			} map {$_->{-fld}
				} grep {ref($_) eq 'HASH'
					} @{$m->{-query}->{-data}}
 }
 elsif	($m->{-field}) {
	map {$k->{$_} =$v->{$_}
		} grep { defined($v->{$_}) && $v->{$_} ne ''
			} map {$_->{-fld}
				} grep {ref($_) eq 'HASH' && ($_->{-flg}||'') =~/[aql]/
					} @{$m->{-field}}
 }
 if (!%$k) {
	map {$k->{$_} =$v->{$_}
		} grep { defined($v->{$_}) && $v->{$_} ne ''
			} keys %{$v};
 }
 $k
}


sub cgiQuery {	# Query records
 my ($s, $n, $m, $c) =@_;
     $m =$s->{-form}->{$n}||$s->mdeTable($n) if !$m;
     $c =$s->{-pcmd} if !$c;
 my  $q =$m->{-query};
 my  %a =$q ? %$q : ();

 $a{-key} ={} if $q->{-key} ||$c->{-qkey};
 @{$a{-key}}{keys %{$q->{-key}}}  =values %{$q->{-key}}  if $q->{-key};
 @{$a{-key}}{keys %{$c->{-qkey}}} =values %{$c->{-qkey}} if $c->{-qkey};

 if	(!$c->{-qwhere})		{}
 elsif	(!$a{-where})			{$a{-where} =$c->{-qwhere}}
 elsif	(ref($a{-where}) eq 'ARRAY')	{push @{$a{-where}}, $c->{-qwhere}}
 elsif	(ref($a{-where}))		{$a{-where} =$c->{-qwhere}}
 else					{$a{-where} ='(' .$a{-where} .') and ' .$c->{-qwhere}}
 
 $a{-urole}	=$c->{-qurole}		if $c->{-qurole};
 $a{-uname}	=$c->{-quname}		if $c->{-quname};
 $a{-ftext}	=$c->{-qftext}		if $c->{-qftext};
 $a{-version}	=$c->{-qversion}	if $c->{-qversion};
 $a{-order}	=$c->{-qorder}		if $c->{-qorder};
 $a{-limit}	=$c->{-qlimit}		if $c->{-qlimit};

 if	(!$a{-data} && $m->{-field}) {
	$a{-data} =[grep {ref($_) eq 'HASH' 
			&& $_->{-fld}
			&& (	  (($_->{-flg}||'') =~/[akwuql]/)
				||(!defined($_->{-flg})
					&& (ref($_->{-inp}) ne 'HASH') 
						? 1 
						: !($_->{-inp}->{-rows}||$_->{-inp}->{-arows}||$_->{-inp}->{-rfd})
					)
				)
			} @{$m->{-field}}];
	delete $a{-data} if !@{$a{-data}};
 }

 $s->recSel(-table=>$m->{-table} ||$n, %a);

}


sub cgiList {	# List queried records
		# self, ?options, form name, ?metadata, ?command, ?iterator, ?borders
 my ($s, $o, $n, $m, $c, $i, $b) =($_[0], substr($_[1],0,1) eq '-' ? @_[1..$#_] : ('-', @_[1..$#_]));
    $m  =$s->{-form}->{$n}||$s->mdeTable($n) if !$m;
    $c  =$s->{-pcmd}||{} if !$c;
 my $xml=$c->{-xml};
 my $mt =  $c->{-field}
	||(ref($i) eq 'HASH' && $i->{-data})
	||($m->{-query} && $m->{-query}->{-data}) 
	|| $m->{-field}
	||($m->{-table} && $s->mdeTable($m->{-table})->{-field});
 my $href  =$c->{-qhref} ||$m->{-qhref} ||{};
    $href->{-form} =$m->{-table}||$n	if (ref($href) eq 'HASH') && !$href->{-form};
    $href->{-cmd}  ='recRead'		if (ref($href) eq 'HASH') && !$href->{-cmd};
	# -formfld, -key
 my @coln  =();
 my @colh  =();
 my @colf  =();
 my $hrcol =(defined($c->{-qhrcol}) ? $c->{-qhrcol} : $m->{-qhrcol}) || 0;
 my $qflgh =$o =~/!.*h/ && ($c->{-qflghtml} || $m->{-qflghtml});
 my $fetch =$c->{-qfetch} || $m->{-qfetch};
 my $limit =$c->{-limit}  || ($m->{-query} && $m->{-query}->{-limit}) ||$m->{-limit} ||$s->{-limit} ||$LIMRS;

 $i =	  !$i 
	? $s->recSel($m->{-query})
	: ref($i) eq 'HASH'
	? $s->recSel($i)
	: ref($i) eq 'ARRAY'
	? eval{my $a =$i; DBIx::Web::ccbHandle->new(sub{shift @$a})}
	: ref($i) eq 'CODE'
	? DBIx::Web::dbmCursor->new($i)
	: $i;
 $i ||return(&{$s->{-die}}('cgiList(' .strdata(@_) .') -> cursor undefined'));
 $b =	  $xml
	? ["\n<table>\n"
		,'<tr>',	    '<td>',			   '<url>',	'</url>',' ',	"</td>\n","</tr>\n","</table>\n"]
	: !$b
	? ["\n<table class=\"_ListTable\">\n"
		,'<tr>',	   '<td align="left" valign="top">','<a href="', '">', '</a>', '</td>', "</tr>\n", "</table>\n"]
	: $b =~/<select/
	? [$b	,'<option value="', '',				    '">',	 '',	'',	'',	"</option>\n",	"</select>\n"]
	: ['<span class="_ListList">'
		,' ',' ',' <a href="','">','</a> ',' ',"$b\n","</span>\n"]
	if !ref($b);

 if (ref($href) eq 'HASH') {
	if	(!$href->{-key}) {		# Hyperlink key
		$href->{-key} =[];
		my $j =0;
		my $k =(ref($m->{-key}) eq 'ARRAY') && $m->{-key};
		foreach my $f (@$mt) {
			next if ref($f) ne 'HASH' ||!$f->{-fld};
			push @{$href->{-key}}, [$f->{-fld} =>$j]
				if ($f->{-flg}||'') =~/[k]/	# 'k'ey
				|| ($k
				&&  grep {$f->{-fld} eq $_} @$k);
			$j++
		}
	}
	elsif (ref($href->{-key}) eq 'ARRAY') {
		foreach my $k (@{$href->{-key}}) {
			next if ref($k);
			my $j =0;
			foreach my $f (@$mt) {
				next if ref($f) ne 'HASH' ||!$f->{-fld};
				if ($k eq $f->{-fld}) {
					$k =[$k, $j];
					last
				}
				$j++
			}
		}
	}
	elsif (!ref($href->{-key})) {
			my $j =0;
			foreach my $f (@$mt) {
				next if ref($f) ne 'HASH' ||!$f->{-fld};
				if ($href->{-key} eq $f->{-fld}) {
					$href->{-key} =$j;
					last
				}
				$j++
			}
	}
	if	($href->{-formfld}) {		# Hyperlink form
		my $j =0;
		foreach my $f (@$mt) {
			next if ref($f) ne 'HASH' ||!$f->{-fld};
			if (($f->{-fld}||'') eq $href->{-formfld}) {
				$href->{-form} =sub{$_[1]->[$j]};
				last
			}
			$j++
		}
	}
	elsif	(defined($href->{-formfld})) {
		$href->{-form} =''
	}
	if	(1) {				# Hyperlink sub{}
		my $hr	=$href;
		$href	=sub{
			 '?' .'_cmd='  .urlEscape($s
				, ref($hr->{-cmd})  ne 'CODE' 
				? $hr->{-cmd}  : (&{$hr->{-cmd}}(@_)))
			.$HS .'_form=' .urlEscape($s
				, ref($hr->{-form}) ne 'CODE' 
				? $hr->{-form} : (&{$hr->{-form}}(@_)))
			.$HS .'_key='  .urlEscape($s
				, !ref($hr->{-key})
				? $_[1]->[$hr->{-key}]
				: ref($hr->{-key}) ne 'CODE'
				? strdatah($s, map {($_->[0] => $_[1]->[$_->[1]])} @{$hr->{-key}})
				: &{$hr->{-key}}(@_))
		};
	}
 }
 $href =sub{''} if !$href;

 if (!@coln)	{				# Display column numbers
	my $j =0;
	foreach my $f (@$mt) {
		next if ref($f) ne 'HASH' ||!$f->{-fld};
		if (ref($f->{-lsthtml}) eq 'CODE') {
			my($i, $c) =($j, $f->{-lsthtml});
			push @coln, sub{local $_=ref($_[2]) ?$_[2]->[$i] :$_[2]; &$c};
			push @colh, $f->{-lbl} ||$s->lng(0, $f->{-fld}) ||'';
			push @colf, [$f->{-fld} || '', $coln[$#coln], $colh[$#colh]];
		}
		elsif (($f->{-flg}||'') =~/[l]/) {
			push @coln, $j;
			push @colh, $f->{-lbl} ||$s->lng(0, $f->{-fld}) ||'';
			push @colf, [$f->{-fld} || '', $coln[$#coln], $colh[$#colh]];
		}
		$j++
	}
	if (!@coln && isa($i, 'HASH'))	{
		@coln	=(0..$#{$i->{NAME}});
		@colh	=@{$i->{NAME}};
		@colf	=map {[$i->{NAME}->[$_], $_, $i->{NAME}->[$_]]} @coln;
		foreach my $h (@colh) {
			foreach my $f (@$mt) {
				next if ref($f) ne 'HASH' ||!$f->{-fld} ||$f->{-fld} ne $h;
				$h =$f->{-lbl} ||$s->lng(0, $f->{-fld}) ||''
			}
		}
	}
 }


 if (ref($fetch) ne 'CODE') {			# Fetch sub{}
	my $ft	=$fetch;
	my $hrc1=$b->[4] || $#coln ? $hrcol+1 : $hrcol;
	$fetch	=sub {
		my $r;
		while($r =$i->fetch()) {
			last	if !$m->{-qfilter} 
				|| &{$m->{-qfilter}}($s, $n, $m, $c, $i->{-rec})
		}
		return(undef)	if !$r;
		if ($qflgh) {
			$s->output((ref($qflgh) eq 'CODE' ? &$qflgh($s) : $qflgh));
			$s->output($b->[0]);
			$qflgh =undef
		}
		my $h =&$href($s, $r);
		$xml
		? $s->output(''
		, xmlsTag($s, 'tr', 'href'=>$s->cgi->url() .'/' .$h, '0')
		, "\n"
		, (map {xmlsTag($s, $_->[0]
				, ''=>	  ref($_->[1])
					? &{$_->[1]}($s, $r)
					: ref($r)
					? $r->[$_->[1]]
					: $r
				, "\n")
			} @colf)
		,$b->[7])
		: $s->output($b->[1]
		, (map {!ref($_)
			? (	 $b->[2] ||htmlEscape($s, ref($r) ? $r->[$_] : $r)
				,$b->[3]
				,$b->[4] && $h, $b->[4]
				,ref($_) 
				? &$_($s, $i, $r)
				: htmlEscape($s, ref($r) ? $r->[$_] : $r)
				,$b->[5], $b->[6])
			: &$_($s, $r, $h)
			} @coln[0..$hrcol])
		, (map { !ref($_)
			? (	 $b->[2]
				,ref($_)
				? &$_($s, $i, $r)
				: htmlEscape($s, ref($r) ? $r->[$_] : $r)
				,$b->[6])
			: &$_($s, $r)
			} @coln[$hrc1..$#coln])
		,$b->[7])
	}
 }


 $s->output($b->[0]) if !$qflgh;		# Table start

 if (@colh && $o !~/!.*h/ && !$xml) {	# Table header
	$s->output('<tr>'
	, (map {('<th align="left" valign="top">' 
		,htmlEscape($s, $_)
		,"</th>\n")} @colh)
	, "</tr>\n")
 }

 my $j =0;
 while (&$fetch($s, $i, $b)) {			# Fetch data
	last if $j++ >$limit;
 }
 $s->{-fetched} =$j;
 $s->{-limited} =$limit;
 eval {$i->finish};

 $s->output($b->[8]) if !$qflgh;		# Table end
}


sub cgiFooter {	# Footer of CGI screen
 my ($s) =@_;
 return(undef) if $s->{-pcmd}->{-xml} ||$s->{-pcmd}->{-print};
 $s->output("\n<span class=\"_FooterArea\"><hr />\n"
	,($s->cgiHook('recList') && defined($s->{-fetched})
	? ('<b>',$s->{-fetched}||0
		,$s->{-limited} && ($s->{-limited} <=$s->{-fetched})
		?('/', $s->{-limited})
		:''
		,' ', $s->lng(1, '-fetched'),"</b><br />\n")
	: defined($s->{-affected})
	? ('<b>',$s->{-affected}||0, ' ', $s->lng(1, '-affected'),"</b><br />\n")
	: ())
	, $s->{-c}->{-logm} && $s->{-debug}
	&& join(";<br />\n",
		map {	$_ =~/^((?:WARN|WARNING|DIE|ERROR)[:.,\s]+)(.*)$/i
			? '<strong>' .htmlEscape($s, $1) .'</strong>' .htmlEscape($s, $2)
			: htmlEscape($s, $_)
			} @{$s->{-c}->{-logm}}
		)
	,"</span>\n");
}


#########################################################
# Default Data Definitions
#########################################################


sub ns {	# Default naming set
		# (self, metaname) -> name
   (($#_ <1) && $_[0]->{-ns})
|| ($_[0]->{-ns}->{$_[1]})
|| (substr($_[1],0,1) eq '-' ? substr($_[1],1) : $_[1])
}


sub ddfRFD {	# RFD (record file attachments) field declaration 
		# self, definition
 my ($s) =@_; return
 {-fld=>''
 ,-flg=>'e'	# 'e'dit
 ,-lbl=>$s->lng(0,'Attachments')
 ,-cmt=>$s->lng(1,'Attachments')
 ,-lblhtml=> sub {
	return('') if !$s->{-pout}->{-file};
	'<a href="' 
	. $s->rfdPath(-urf=>$s->{-pcmd}, $s->{-pout})
	.'" target="_blank" '
	.' title="' .$s->htmlEscape($s->lng(1,'Attachments')) .'">'
	.($s->{-icons} && $IMG->{'Attachments'}
	 ? '<img src="' .$s->{-icons} .'/' .$IMG->{'Attachments'} .'" border=0 />'
		.'</a> '
	 : $s->htmlEscape($s->lng(0,'Attachments')) .'</a>: ');
 }
 ,-inp=>{-rfd=>1}
 ,@_ > 1 ? @_[1..$#_] : ()
 }
}


sub ddoRVC {	# Record Version Control default data definition
	(-key		=> $_[0]->{-ns}->{-key}
	,-rvcInsBy	=> $_[0]->{-ns}->{-rvcInsBy}
	,-rvcInsWhen	=> $_[0]->{-ns}->{-rvcInsWhen}
	,-rvcUpdBy	=> $_[0]->{-ns}->{-rvcUpdBy}
	,-rvcUpdWhen	=> $_[0]->{-ns}->{-rvcUpdWhen}
	,-rvcActPtr	=> $_[0]->{-ns}->{-rvcActPtr}
	,-rvcFinState	=> $_[0]->{-ns}->{-rvcFinState}
	,-rvcCkoState	=> $_[0]->{-ns}->{-rvcCkoState}
	,-rvcDelState	=> $_[0]->{-ns}->{-rvcDelState}
	,@_ > 1 ? @_[1..$#_] : ())
}


sub ddvRVV {	# Record Versions View default data definition
		# 'version' materialized view definition
		# self, fields, definitions
	my $s =$_[0]; return
	{-lbl	=>	$s->lng(0,'ddvRVV')
	,-cmt	=>	$s->lng(1,'ddvRVV')
	,-field	=>	[
		 {-fld=>'table',			-edit=>0, -flg=>'uql'}
		,{-fld=>$s->{-ns}->{-rvcActPtr},	-edit=>0, -flg=>'uql'}
		,''
		,{-fld=>'id',				-edit=>0, -flg=>'uql'}
		,{-fld=>$s->{-ns}->{-rvcInsWhen},	-edit=>0, -flg=>'uq'}
		,''
		,{-fld=>$s->{-ns}->{-rvcInsBy},		-edit=>0, -flg=>'uq'}
		,{-fld=>$s->{-ns}->{-rvcUpdWhen},	-edit=>0, -flg=>'uql'}
		,''
		,{-fld=>$s->{-ns}->{-rvcUpdBy},		-edit=>0, -flg=>'uql'}
		,{-fld=>$s->{-ns}->{-rvcState},		-edit=>0, -flg=>'uql'}
		,''
		,{-fld=>'subject',			-edit=>0, -flg=>'uql'}
		,{-fld=>'readers',			-edit=>0, -flg=>'u'}
		,{-fld=>'cargo',			-edit=>0, -flg=>'u'}
		,ref($_[1]) eq 'ARRAY' ? @{$_[1]} : ()
		]
	,-key	=>	['table',$s->{-ns}->{-rvcActPtr},'id']
	,-racReader=>	['readers']
	,-rvcInsBy=>	$s->{-ns}->{-rvcInsBy}
	,-rvcUpdBy=>	$s->{-ns}->{-rvcUpdBy}
	,-rvcActPtr=>	$s->{-ns}->{-rvcActPtr}
	,-query	=>	{-version=>'+'}
	,-ixcnd	=>	sub{$_[2]->{'id'}}
	,-ixrec	=>	sub{my $m =$_[0]->{-table}->{$_[1]->{-table}};
		return(
		{'table'	=>$_[1]->{-table}
		,$s->{-ns}->{-rvcActPtr}	=>$m->{-rvcActPtr} && $_[2]->{$m->{-rvcActPtr}}
		,'id'		=>$_[2]->{'id'}
		,$s->{-ns}->{-rvcInsWhen}=>$m->{-rvcInsWhen} && $_[2]->{$m->{-rvcInsWhen}}
		,$s->{-ns}->{-rvcInsBy}	 =>$m->{-rvcInsBy}   && $_[2]->{$m->{-rvcInsBy}}
		,$s->{-ns}->{-rvcUpdWhen}=>$m->{-rvcUpdWhen} && $_[2]->{$m->{-rvcUpdWhen}}
		,$s->{-ns}->{-rvcUpdBy}	 =>$m->{-rvcUpdBy}   && $_[2]->{$m->{-rvcUpdBy}}
		,$s->{-ns}->{-rvcState}	 =>$m->{-rvcFinState}&& $_[2]->{$m->{-rvcFinState}->[0]}
		,'subject'	=>join(' '
				,(map {$_[2]->{$_}
					} grep {$_[2]->{$_}
						} qw(record object subject))
				)
		,'readers'	=>join(',', map {$_[2]->{$_}||''} 
				grep {$_[2]->{$_}} 
				@{$m->{-racReader}||$_[0]->{-racReader}||[]}
				, @{$m->{-racWriter}||$_[0]->{-racWriter}||[]})
		,'cargo'	=>join("\t",map {$_[2]->{$_}||''} 
				grep {$_[2]->{$_}} keys %{$_[2]})
		})}
	,-qhref	=>	{-formfld	=>'table'
			,-key		=>['id']	# [['id'=>2]]
			}
	,@_ > 2 ? @_[2..$#_] : ()
	}
}


sub ddfRVE {	# Record Versions Embedded view default field definition
 my ($s, $v) =@_;	# (self, version store)
 $v ='version' if !$v;
 sub{	
	return('')	if ($_[0]->{-pcmd}->{-cmg} eq 'recQBF')
			|| !$_[0]->{-pcmd}->{-table}
			|| !$_[0]->{-pout}->{'id'}
			|| $_[0]->{-pcmd}->{-print};
	$_[0]->output("\n<font size=\"-1\">") if !$_[0]->{-pcmd}->{-xml};
	$_[0]->cgiList('-!h'
		,$v, undef
		,{-qhrcol=>1, -qflghtml=>$_[0]->cgi->hr() .$_[0]->lng(0,'ddvRVV') .': '}
		,{-key=>{'table'=>$_[0]->{-pcmd}->{-table}
			,$_[0]->{-ns}->{-rvcActPtr}=>$_[0]->{-pout}->{'id'}}
		 ,-table=>$v
		 ,-order=>'-deq'
		 ,-version=>1
		 ,-data=>[{-fld=>'table',			-flg=>'q'}
			 ,{-fld=>'id',				-flg=>'q'}
			 ,{-fld=>$_[0]->{-ns}->{-rvcUpdBy},	-flg=>'ql'}
			 ,{-fld=>$_[0]->{-ns}->{-rvcUpdWhen},	-flg=>'ql'}]
		 },'; ');
	$_[0]->output("\n</font>\n") if !$_[0]->{-pcmd}->{-xml};
	''
 }
}


sub ddvRHV {	# Records History View default data definition
		# 'history' materialized view definition
		# self, fields, definition
	my $s =$_[0]; return
	{-lbl	=>	$s->lng(0,'ddvRHV')
	,-cmt	=>	$s->lng(1,'ddvRHV')
	,-field	=>	[
		 {-fld=>$s->{-ns}->{-rvcInsWhen},	-edit=>0, -flg=>'uq'}
		,''
		,{-fld=>$s->{-ns}->{-rvcInsBy},		-edit=>0, -flg=>'uq'}
		,{-fld=>$s->{-ns}->{-rvcUpdWhen},	-edit=>0, -flg=>'uql'}
		,''
		,{-fld=>$s->{-ns}->{-rvcUpdBy},		-edit=>0, -flg=>'uql'}
		#	,{-fld=>'table', -edit=>0, -flg=>'uq'}
		#	,''
		,{-fld=>'id',				-edit=>0, -flg=>'uq'}
		,{-fld=>$s->{-ns}->{-rvcState},		-edit=>0, -flg=>'uql'}
		,''
		,{-fld=>$s->{-ns}->{-rvcActPtr},	-edit=>0, -flg=>'uq'}
		,{-fld=>'subject',			-edit=>0, -flg=>'uql'}
		,{-fld=>'auser',			-edit=>0, -flg=>'uql'}
		,''
		,{-fld=>'arole',			-edit=>0, -flg=>'uql'}
		,{-fld=>'puser',			-edit=>0, -flg=>'uq'}
		,''
		,{-fld=>'prole',			-edit=>0, -flg=>'uq'}
		,{-fld=>'readers',			-edit=>0, -flg=>'u'}
		,{-fld=>'cargo',			-edit=>0, -flg=>'u'}
		,ref($_[1]) eq 'ARRAY' ? @{$_[1]} : ()
		]
	,-key	=>	[$s->{-ns}->{-rvcUpdWhen},$s->{-ns}->{-rvcUpdBy},'id']	# ,'table'
	,-racReader=>	['readers']
	,-racPrincipal=>['puser','prole']
	,-racActor=>	['auser','arole']
	,-rvcInsBy=>	$s->{-ns}->{-rvcInsBy}
	,-rvcUpdBy=>	$s->{-ns}->{-rvcUpdBy}
	,-rvcActPtr=>	$s->{-ns}->{-rvcActPtr}
	,-ixcnd	=>	sub{$_[2]->{'id'} && $_[2]->{$s->{-ns}->{-rvcUpdWhen}}}
	,-ixrec	=>	sub{
		my $m	=$_[0]->{-table}->{$_[1]->{-table}};
		my $ra	= mdeRole($_[0], $m, 'authors');
		my $rp	= mdeRole($_[0], $m, 'principals');
		return(
		{'id'		=>$_[1]->{-table} .$RISM1 .$_[2]->{'id'}
		#'table'	=>$_[1]->{-table}
		#'id'		=>$_[2]->{'id'}
		,$_[0]->{-ns}->{-rvcInsWhen}=>$m->{-rvcInsWhen} && $_[2]->{$m->{-rvcInsWhen}}
		,$_[0]->{-ns}->{-rvcInsBy}	 =>$m->{-rvcInsBy}   && $_[2]->{$m->{-rvcInsBy}}
		,$_[0]->{-ns}->{-rvcUpdWhen}=>$m->{-rvcUpdWhen} && $_[2]->{$m->{-rvcUpdWhen}}
		,$_[0]->{-ns}->{-rvcUpdBy}	 =>$m->{-rvcUpdBy}   && $_[2]->{$m->{-rvcUpdBy}}
		,$_[0]->{-ns}->{-rvcState}	 =>$m->{-rvcFinState}&& $_[2]->{$m->{-rvcFinState}->[0]}
		,$_[0]->{-ns}->{-rvcActPtr} =>$m->{-rvcActPtr}  && $_[2]->{$m->{-rvcActPtr}}
		,'subject'	=>join(' '
				,(map {$_[2]->{$_}
					} grep {$_[2]->{$_}
						} qw(record object subject))
				)
		,'auser'	=>(!$ra 		? undef
				: !ref($ra)		? $_[2]->{$ra}
				: @$ra && $ra->[0]	? $_[2]->{$ra->[0]}
				: undef)
				|| $_[2]->{$m->{-rvcUpdBy} ||$_[0]->{-rvcUpdBy} ||''}
		,'arole'	=>!ref($ra) || $#$ra <1
				? undef
				: join(',', map {!$_[2]->{$_} ? () : ($_[2]->{$_})
					} @$ra[1..$#$ra])
		,'puser'	=>(!$rp 		? undef
				: !ref($rp)		? $_[2]->{$rp}
				: @$rp && $rp->[0]	? $_[2]->{$rp->[0]}
				: undef)
				|| $_[2]->{$m->{-rvcInsBy} ||$_[0]->{-rvcInsBy} ||''}
		,'prole'	=>!ref($rp) || $#$rp <1
				? undef
				: join(',', map {!$_[2]->{$_} ? () : ($_[2]->{$_})
					} @$rp[1..$#$rp])
		,'readers'	=>join(',', map {$_[2]->{$_}||''} 
				grep {$_[2]->{$_}} 
				@{$m->{-racReader}||$_[0]->{-racReader}||[]}
				, @{$m->{-racWriter}||$_[0]->{-racWriter}||[]})
		,'cargo'	=>join("\t",map {$_[2]->{$_}||''} 
				grep {$_[2]->{$_}} keys %{$_[2]})
		})}
	,-qhref	=>	{-formfld	=>''	# 'table'
			,-key		=>'id'	# ['id'] # [['id'=>3]]
			}
	,-query	=>	{-order		=>'-dall'}
	,@_ > 2 ? @_[2..$#_] : ()
	}
}



sub ddvRRV {	# Records References View default data definition
		# 'references' materialized view definition
		# self, fields, definition
	my $s =$_[0]; return
	{-lbl	=>	$s->lng(0,'ddvRRV')
	,-cmt	=>	$s->lng(1,'ddvRRV')
	,-field	=>	[
		 {-fld=>'ir',				-edit=>0, -flg=>'uql'}
		,''
		,{-fld=>'id',				-edit=>0, -flg=>'uql'}

		,{-fld=>$s->{-ns}->{-rvcInsWhen},	-edit=>0, -flg=>'uq'}
		,''
		,{-fld=>$s->{-ns}->{-rvcInsBy},		-edit=>0, -flg=>'uq'}
		,{-fld=>$s->{-ns}->{-rvcUpdWhen},	-edit=>0, -flg=>'uql'}
		,''
		,{-fld=>$s->{-ns}->{-rvcUpdBy},		-edit=>0, -flg=>'uq'}

		,{-fld=>$s->{-ns}->{-rvcState},		-edit=>0, -flg=>'uql'}
		,''
		,{-fld=>$s->{-ns}->{-rvcActPtr},	-edit=>0, -flg=>'uq'}
		,{-fld=>'subject',			-edit=>0, -flg=>'uql'}
		,{-fld=>'auser',			-edit=>0, -flg=>'uql'}
		,''
		,{-fld=>'arole',			-edit=>0, -flg=>'uql'}
		,{-fld=>'puser',			-edit=>0, -flg=>'uq'}
		,''
		,{-fld=>'prole',			-edit=>0, -flg=>'uq'}
		,{-fld=>'readers',			-edit=>0, -flg=>'u'}
		,ref($_[1]) eq 'ARRAY' ? @{$_[1]} : ()
		]
	,-key	=>	['ir',$s->{-ns}->{-rvcUpdWhen},'id']
	,-qhrcol=>	1
	,-racReader=>	['readers']
	,-racPrincipal=>['puser','prole']
	,-racActor=>	['auser','arole']
	,-rvcInsBy=>	$s->{-ns}->{-rvcInsBy}
	,-rvcUpdBy=>	$s->{-ns}->{-rvcUpdBy}
	,-rvcActPtr=>	$s->{-ns}->{-rvcActPtr}
	,-ixcnd	=>	sub{$_[2]->{'id'} 
			&& ($_[0]->{-table}->{$_[1]->{-table}}->{-ridRef}
				||$_[0]->{-ridRef})}
	,-ixrec	=>	sub{
		my $s  =$_[0];
		my $m  =$s->{-table}->{$_[1]->{-table}};
		my $ir =[];
		my $id =$_[1]->{-table} .$RISM1 .$_[2]->{'id'};
		foreach my $f (@{$m->{-ridRef} ||$s->{-ridRef}}) {
			if (!$_[2]->{$f}) {
				next
			}
			elsif ($_[2]->{$f} =~/[\s,.?]/) {
				my $v =$_[2]->{$f};
				while ($v =~/(?:_key=id%3D|_key=)([\w\d]+\Q$RISM1\E[\w\d]+)/i) {
					push @$ir, $1;
					$v =$'
				}
			}
			elsif (length($_[2]->{$f}) >$NLEN *3) {
				next
			}
			elsif ($_[2]->{$f} =~/\Q$RISM1\E/) {
				push @$ir, $_[2]->{$f}
			}
			else {
				push @$ir, $_[1]->{-table} .$RISM1 .$_[2]->{$f}
			}
		}
		return($ir) if !@$ir;
		my $ra	= mdeRole($_[0], $m, 'authors');
		my $rp	= mdeRole($_[0], $m, 'principals');
		my $rv	=
		{'id'		=>$id
				# below alike 'ddvRHV'
		,$s->{-ns}->{-rvcInsWhen}=>$m->{-rvcInsWhen} && $_[2]->{$m->{-rvcInsWhen}}
		,$s->{-ns}->{-rvcInsBy}  =>$m->{-rvcInsBy}   && $_[2]->{$m->{-rvcInsBy}}
		,$s->{-ns}->{-rvcUpdWhen}=>$m->{-rvcUpdWhen} && $_[2]->{$m->{-rvcUpdWhen}}
		,$s->{-ns}->{-rvcUpdBy}	 =>$m->{-rvcUpdBy}   && $_[2]->{$m->{-rvcUpdBy}}
		,$s->{-ns}->{-rvcState}	 =>$m->{-rvcFinState}&& $_[2]->{$m->{-rvcFinState}->[0]}
		,$s->{-ns}->{-rvcActPtr} =>$m->{-rvcActPtr}  && $_[2]->{$m->{-rvcActPtr}}
		,'subject'	=>join(' '
				,(map {$_[2]->{$_}
					} grep {$_[2]->{$_}
						} qw(record object subject))
				)
		,'auser'	=>(!$ra 		? undef
				: !ref($ra)		? $_[2]->{$ra}
				: @$ra && $ra->[0]	? $_[2]->{$ra->[0]}
				: undef)
				|| $_[2]->{$m->{-rvcUpdBy} ||$_[0]->{-rvcUpdBy} ||''}
		,'arole'	=>!ref($ra) || $#$ra <1
				? undef
				: join(',', map {!$_[2]->{$_} ? () : ($_[2]->{$_})
					} @$ra[1..$#$ra])
		,'puser'	=>(!$rp 		? undef
				: !ref($rp)		? $_[2]->{$rp}
				: @$rp && $rp->[0]	? $_[2]->{$rp->[0]}
				: undef)
				|| $_[2]->{$m->{-rvcInsBy} ||$_[0]->{-rvcInsBy} ||''}
		,'prole'	=>!ref($rp) || $#$rp <1
				? undef
				: join(',', map {!$_[2]->{$_} ? () : ($_[2]->{$_})
					} @$rp[1..$#$rp])
		,'readers'	=>join(',', map {$_[2]->{$_}||''} 
				grep {$_[2]->{$_}} 
				@{$m->{-racReader}||$s->{-racReader}||[]}
				, @{$m->{-racWriter}||$s->{-racWriter}||[]})
		};
		map {$_ ={'ir'=>$_, %$rv}} @$ir;
		$ir}
	,-qhref	=>	{-formfld	=>''
			,-key		=>'id'
			}
	,-query	=>	{-order		=>'-dall'}
	,@_ > 2 ? @_[2..$#_] : ()
	}
}


sub ddfRRE {	# Record References Embedded view default field definition
 my ($s, $v) =@_;	# (self, references store)
 $v ='reference' if !$v;
 sub{	
	return('') 
		if ($_[0]->{-pcmd}->{-cmg} eq 'recQBF')
		|| !$_[0]->{-pcmd}->{-table}
		|| !$_[0]->{-pout}->{'id'};
	$_[0]->output("\n<font size=\"-1\">") if !$_[0]->{-pcmd}->{-xml};
	$_[0]->cgiList('-!h'
	,$v, undef
	,{-qhrcol=>0, -qflghtml=>$_[0]->cgi->hr()} # .$_[0]->lng(0,'ddvRRV') .': '
	,{-key=>{'ir'=>$_[0]->{-pcmd}->{-table} .$RISM1 .$_[0]->{-pout}->{'id'}}
	 ,-table=>$v
	 ,-order=>'-deq'
	 ,-version=>0
	 ,-data=>[{-fld=>'ir',				-flg=>'q'}
		 ,{-fld=>'id',				-flg=>'q'}
		 ,{-fld=>$_[0]->{-ns}->{-rvcUpdWhen},	-flg=>'ql'}
		 ,{-fld=>$_[0]->{-ns}->{-rvcState},	-flg=>'ql'}
		 ,{-fld=>'subject',			-flg=>'ql'}
		 ,{-fld=>'auser',			-flg=>'ql'}
		 ,{-fld=>'arole',			-flg=>'ql'}]
	});
	$_[0]->output("\n</font>\n") if !$_[0]->{-pcmd}->{-xml};
	''
 }
}


sub ddfShow {	# Show detail default feature definition for '-lblhtml'
		# (self, ? input name, ? [detail fields], ? html pattern)
 my ($s, $n, $d, $h) =@_;
 sub{	my $x =!$h ? '$_' : ref($h) eq 'CODE' ? &$h(@_) : $h;
	   $_[3]
	|| $_[0]->{-pdta}->{$n||'ddfShow_'}
	|| ($d && !grep {!$_[0]->{-pout}->{$_}} @$d)
	? $x
	: ($x
	  .'<input type="submit" name="' .($n||'ddfShow_')
	  .'" value="' .$_[0]->lng(0,'ddlbopen') 
	  .'" title="' .$_[0]->lng(1,'ddlbopen') 
	  .'" />')
 }
}


sub ddfHide {	# '-hide' detail feature default definition
		# (self, ? input name)
 my ($s, $n) =@_;
 sub {!($_ || $_[0]->{-pdta}->{$n||'ddfShow_'} ||$_[3])}
}


sub ddvIndex {	# Index page default data definition
 my $s =$_[0];
 (-lbl		=>$s->lng(0,'ddvIndex')
 ,-cmt		=>$s->lng(1,'ddvIndex')
 ,-cgcCall	=>sub{
	my $s =$_[0];
	$s->{-fetched}	=undef;
	$s->{-affected}	=undef;
	$s->output($s->htmlStart()		# HTTP/HTML/Form headers
		,$s->htmlHidden(@_[1,2])	# common hidden fields
		,!$s->{-pcmd}->{-print}
		&& $s->htmlMenu(@_[1,2])	# Menu bar
		,"\n<table class=\"_ListTable\">\n"
		);
	foreach my $e	(($s->{-menuchs} ? @{$s->{-menuchs}} : ())
			,($s->{-menuchs1}? @{$s->{-menuchs1}}: ())
			) {
		my ($n, $l) = ref($e) ? @$e : ($e, $e);
		my ($o, $a) = $n =~/^(.+?)([+&.]+)$/ ? ($1, $2) : ($n, $n);
		my $l0 =($s->{-form}->{$o} ||$s->{-table}->{$o} ||{})->{-lbl}||'';
		my $l1 =($s->{-form}->{$o} ||$s->{-table}->{$o} ||{})->{-cmt}||'';
		$s->output('<tr><th align="left" valign="top">'
			, $n
			? $s->cgi->a({-href=>$s->urlCat('','_form'=>$n,'_cmd'=>'frmCall')
				,-title=>  $a =~/[+]/ 
					? $s->lng(0,'Create')	." '$l0'"
					: $a =~/[&.]/
					? $s->lng(0,'Open')	." '$l0'"
					: $s->lng(0,'View')	." '$l0'"
				}
				,(!$s->{-icons}
				? ''
				: '<img border="0" src="' .$s->{-icons} .'/'
				. ( $a =~/[+]/  ? $IMG->{'recNew'}
				  : $a =~/[&.]/ ? $IMG->{'frmCall'}
				  : $IMG->{'recList'}
				  ) .'">')
				. $s->htmlEscape($l0))
			: $s->htmlEscape($l)
			, "</th>\n"
			, '<td>&nbsp;</td><td align="left" valign="bottom">'
			, $s->htmlEscape( !$l1 || $l1 ne $l0
					? $l1
					: $a =~/[+]/ 
					? $s->lng(0,'Create')	." '$l0'"
					: $a =~/[&.]/
					? $s->lng(0,'Open')	." '$l0'"
					: $s->lng(0,'View')	." '$l0'"
					)
			, "</td></tr>\n"
			)
		}
	$s->output("\n</table>\n");
	# $s->recCommit();
	$s->cgiFooter() if !$s->{-pcmd}->{-print};
	$s->htmlEnd();
	$s->end();
	}
 )
}

sub ddvFTQuery {	# Full-Text Query
 my $s =$_[0];
 (-lbl		=>$s->lng(0,'ddvFTQuery')
 ,-cmt		=>$s->lng(1,'ddvFTQuery')
 ,-cgcCall	=>sub{
	my $s =$_[0];
	my $g =$s->cgi();
	$s->{-fetched}	=0;
	$s->{-affected}	=undef;
	$s->{-pcmd}->{-cmd} =$s->{-pcmd}->{-cmg} ='recQBF';
	$s->output($s->htmlStart()		# HTTP/HTML/Form headers
		,$s->htmlHidden(@_[1,2])	# common hidden fields
		,!$s->{-pcmd}->{-print}
		&& $s->htmlMenu(@_[1,2])	# Menu bar
		,"\n"
		);
	$s->die('Microsoft IIS required')	if $ENV{SERVER_SOFTWARE} !~/IIS/;
	$g->param('_qftwhere'
		, defined($g->param('_qftwhere')) && ($g->param('_qftwhere') ne '')
		? $g->param('_qftwhere')
		: defined($g->param('_qftext')) && ($g->param('_qftext') ne '')
		? $g->param('_qftext')
		: '');
	$s->output($g->textfield(-name=>'_qftwhere', -size=>70, -title=>$s->lng(1,'-qftwhere'))
		, $g->submit(-name =>'_qftCall'
			,-value=>$s->lng(0,'qftCall')
			,-title=>$s->lng(1,'qftCall'))
		, '<br />'
		, $g->popup_menu(-name=>'_qftord'
			,-values=>['write','hitcount','vpath','docauthor']
			,-labels=>{
				 'write'	=>'Chronologically'
				,'hitcount'	=>'Ranked'
				,'vpath'	=>'by Name'
				,'docauthor'	=>'by Author'
				}
			,-default=>'write')
		, $g->popup_menu(-name=>'_qlimit'
			,-values=>['',128,256,512,1024,2048,4096]
			,-labels=>{
				 ''  =>"$LIMRS default"
				,128 =>'128  max'
				,256 =>'256  max'
				,512 =>'512  max'
				,1024=>'1024 max'
				,2048=>'2048 max'
				,4096=>'4096 max'
				}
			,-default=>$LIMRS)
		, $g->a({-href=>
			-e ($ENV{windir} .'/help/ix/htm/ixqrylan.htm')
			? '/help/microsoft/windows/ix/htm/ixqrylan.htm'
			: '/help/microsoft/windows/isconcepts.chm' # .'::/ismain-concepts_30.htm'
			}, '?')
		, "<br />\n");

	if ($g->param('_qftwhere') ne '') {
		eval('use Win32::OLE');
		Win32::OLE->Initialize();
		# Win32::OLE->Initialize(&Win32::OLE::COINIT_OLEINITIALIZE);
		# Search MSDN for 'ixsso.Query'
		my $oq =Win32::OLE->CreateObject("ixsso.Query");
		!$oq && $s->die("'OLE->CreateObject(ixsso.Query)' failed '$!'/'$@'/" .Win32::OLE->LastError);
		my $ou =Win32::OLE->CreateObject("ixsso.util");
		!$oq && $s->die("'OLE->CreateObject(ixsso.util)' failed '$!'/'$@'/" .Win32::OLE->LastError);
		my $qs =[];
		my $qt =[];
		$oq->{Query} =$g->param('_qftwhere') =~/^(@\w|\{\s*prop\s+name\s+=)/i
				? $g->param('_qftwhere')
				: ('@contents ' .$g->param('_qftwhere'));
		$oq->{Catalog}    ='Web';
		$oq->{MaxRecords} =$g->param('_qlimit') ||$LIMRS;
		$oq->{MaxRecords} =4096 if $oq->{MaxRecords} >4096;
		$oq->{SortBy}     =$g->param('_qftord') ||'write';
		$oq->{SortBy}    .=$oq->{SortBy} =~/^(write|hitcount)$/i 
				? '[d],docauthor[a]' 
				: '[a],write[d]';
		$oq->{Columns}    ='vpath,path,filename,hitcount,write,doctitle,docauthor,characterization';
		$oq->{LocaleID}   =1049; # ru

		my $ol =eval {$oq->CreateRecordset('sequential')}; # 'nonsequential'
		!$oq && $s->die("'OLE->CreateRecordset(sequential)' failed '$!'/'$@'/" .Win32::OLE->LastError);
		$s->output('No records found') if $ol->{EOF};

		my ($rcf, $rct, $rcd) =(0, 0, 0);
		while (!$ol->{EOF}) {
			my $vp =$ol->{vPath}->{Value};
			$rcf +=1;
			if (!$vp) {
				$rct +=1;
			}
			if ($vp) {
				$rcd +=1;
				my $vt =$g->escapeHTML($ol->{DocTitle}->{Value});
				$vt = ($vt ? '$vt' .'&nbsp;&nbsp;' : '')
				. '(' .$g->escapeHTML($ol->{DocAuthor}->{Value}) .')'
					if $ol->{DocAuthor}->{Value};
				$vt = ($vt ? $vt .'&nbsp;&nbsp;&nbsp;(' : '')
					. $g->escapeHTML($vp) .')';
				$s->output($g->a({-href=>$vp||$ol->{Path}->{Value}
						,-title=>$ol->{HitCount}->{Value}
						.': ' .$ol->{Path}->{Value}}
						, $vt)
					, $ol->{Characterization}->{Value}
					? '<br />' .$g->escapeHTML($ol->{Characterization}->{Value})
					: ''
					, "<br /><br />\n");
			}
			if (!eval {$ol->MoveNext; 1}) {
				$s->output('Bad query');
				last
			}
		}
		Win32::OLE->FreeUnusedLibraries;
		# Win32::OLE->Uninitialize;
		$s->{-fetched}	=$rcd;
		$s->{-affected}	=$rcf;
		$s->logRec('FTQuery',-fetched=>$rcd, -found=>$rcf, -vpathgen=>$rct, -max=>($oq->{MaxRecords}||'undef'));
	}
	else  {
		$s->output('Enter query condition')
	}
	$s->{-pcmd}->{-cmd} =$s->{-pcmd}->{-cmg} ='recList';
	$s->cgiFooter() if !$s->{-pcmd}->{-print};
	$s->htmlEnd();
	$s->end();
 })
}

sub ddvAll {	# All predefined Views default definitions
 return(
	 'version'	=>$_[0]->ddvRVV()
	,'history'	=>$_[0]->ddvRHV()
	,'reference'	=>$_[0]->ddvRRV()
 )
}


sub ddfAll {	# All predefined Fields default definitions
 return(
	 $_[0]->ddfRFD()
	,$_[0]->ddfRVE()
	,$_[0]->ddfRRE()
 )
}


#########################################################
# File Handle Object
#########################################################



package DBIx::Web::FileHandle;
use strict;
use Symbol;
use Fcntl qw(:DEFAULT :flock :seek :mode);

sub new {
  my ($c, %o) =@_;
  my $s ={-name  =>''       # file name
         ,-mode  =>'<'      # file open mode
         ,-parent=>undef    # parent object
         ,-handle=>undef    # Symbol::gensym on file open
         ,-lock  =>LOCK_UN  # lock level
         ,-lcks  =>{}       # locks
       # ,-new   =>undef    # new file created
       # ,-buf   =>undef    # file contents from 'loadXX' calls
       # ,-ret   =>undef    # data to return, for external programming
         };
  foreach my $k (keys(%o)) {$s->{$k} =$o{$k}}
  bless $s, $c;
  $s->open() if defined($s->{-name}) && $s->{-name} ne '';
  $s
}


sub set {
 return(keys(%{$_[0]})) if scalar(@_) ==1;
 return($_[0]->{$_[1]}) if scalar(@_) ==2;
 my ($s, %o) =@_;
 foreach my $k (keys(%o)) {$s->{$k} =$o{$k}};
 $s
}


sub parent {
 $_[0]->{-parent}
}


sub open {
 my $s =shift;
 if    (!@_) {}
 elsif ($_[0] =~/^-(name|mode)$/) {$s->set(@_)}
 else  {foreach my $k ('-mode','-name') {$s->{$k} =shift if defined($_[0])}}
 $s->{-new} =!-e $s->{-name};
 $s->{-lcks}={};
 if (!CORE::open($s->{-handle} =Symbol::gensym, $s->{-mode}, $s->{-name})) {
    $s->{-handle} =undef;
    return(&{$s->{-parent} ? $s->{-parent}->{-die} : \&die}
           ("File: open('" .($s->{-mode}||'') ."','" .($s->{-name}||'') ."') -> $!") ||undef)
 }
 $s
}


sub opent {
 return($_[0]) if $_[0]->{-handle};
 $_[0]->open() || return(undef);
 $_[0]->lock($_[0]->{-lock}) if $_[0]->{-lock} ne LOCK_UN;
 $_[0]
}


sub binmode {
 CORE::binmode($_[0]->{-handle}); $_[0]
}

sub close {
 return($_[0]) if !$_[0]->{-handle};
 $_[0]->lock(LOCK_UN) if $_[0]->{-lock} ne LOCK_UN;
 $_[0]->{-lcks}={};
 CORE::close($_[0]->{-handle}); 
 $_[0]->{-handle} =undef;
 $_[0]
}


sub destroy {
 eval{$_[0]->close()} if $_[0]->{-handle};
 $_[0]->{-parent} =undef;
 $_[0]
}


sub DESTROY {
 destroy(@_)
}


sub lock  { # ?lock value, ?lock key
 # LOCK_SH ==1; LOCK_EX ==2, or LOCK_UN ==8, LOCK_NB ==4 
 return($_[0]->{-lock}) if !defined($_[1]);
 my $l =!$_[1] ? LOCK_UN : $_[1];
 my $lv=$l | LOCK_NB ^ LOCK_NB;
 $_[0]->opent() if !$_[0]->{-handle};
 if ($_[0]->{-lock} ne $lv) {
    if ($lv eq LOCK_UN) {
       CORE::flock($_[0]->{-handle}, $_[0]->{-lock} =LOCK_UN);
       if (!defined($_[2])) { $_[0]->{-lcks} ={} }
       else                 { delete $_[0]->{-lcks}->{$_[2]} }
       $l =0; map {$l =$_ if $l <$_} values %{$_[0]->{-lcks}};
       $_[0]->{-lock} =$lv =$l if $l && CORE::flock($_[0]->{-handle}, $l);
    }
    else {
       CORE::flock($_[0]->{-handle}, $_[0]->{-lock} =LOCK_UN);
       $_[0]->{-lock} =$lv if CORE::flock($_[0]->{-handle}, $l);
    }
 }
 if    (!defined($_[2]))	{ $_[0]->{-lcks} ={} }
 elsif ($lv eq LOCK_UN
    ||  $_[0]->{-lock} ne $lv )	{ delete $_[0]->{-lcks}->{$_[2]} }
 else				{ $_[0]->{-lcks}->{$_[2]} =$lv }
 $_[0]->{-lock} eq $lv ? $_[0] : undef
}


sub seek {
  # WHENCE: 0 - SEEK_SET - to set the new position to POSITION, 
  #         1 - SEEK_CUR - to set it to the current position plus POSITION, 
  #         2 - SEEK_END - to set it to EOF plus POSITION 
  return(CORE::tell($_[0]->{-handle})) if @_ <2;
  CORE::seek($_[0]->{-handle}, $_[1], defined($_[2]) ?$_[2] :SEEK_SET) 
   ? $_[0] 
   : (&{$_[0]->{-parent} ? $_[0]->{-parent}->{-die} : \&die}
      ("File: seek('" .($_[0]->{-name}||'') ."') -> $!") ||undef)
}


sub read {
 my $r =CORE::read($_[0]->{-handle}, $_[1], $_[2], $_[3]||0);
 return(&{$_[0]->{-parent} ? $_[0]->{-parent}->{-die} : \&die}
        ("File: read('" .($_[0]->{-name}||'') ."') -> $!") ||undef)
     if !defined($r);
 $r
}


sub readline {
 CORE::readline($_[0]->{-handle})
}


sub print {
 my $s =shift;
 my $h =$s->{-handle};
 return(&{$s->{-parent} ? $s->{-parent}->{-die} : \&die}
        ("File: print('" .($s->{-name}||'') ."') -> $!") ||undef)
     if !CORE::print $h @_;
 $s
}

sub load {
 my $b ='';
 my $l =$_[0]->{-lock};
 $_[0]->opent() if !$_[0]->{-handle};
 $_[0]->lock(LOCK_SH) if $l eq LOCK_UN;
 $_[0]->{-buf} =defined($_[0]->seek(0)->read($b, -s $_[0]->{-handle})) ? $b : undef;
 $_[0]->lock(LOCK_UN) if $l eq LOCK_UN;
 defined($_[0]->{-buf}) ? $_[0] : undef;
}


sub store {
 my $s =shift;
 my $l =$s->{-lock};
 $s->opent() if !$s->{-handle};
 $s->lock(LOCK_EX) if $l eq LOCK_UN;
 truncate($s->{-handle}, 0);
 my $r =$s->seek(0)->print(@_ ? @_ : $s->{-buf});
 $s->lock(LOCK_UN) if $l eq LOCK_UN;
 $r
}


sub select {
 my $r;
 ref($_[1]) eq 'CODE'
 ? select((select($_[0]->{-handle}), $r =&{$_[1]}(@_))[0]) && $r
 : select($_[0]->{-handle})
}



#########################################################
# DB_File ISAM Handle Object
#########################################################



package DBIx::Web::dbmHandle;
use strict;
use Symbol;
use Fcntl qw(:DEFAULT :flock :seek :mode);

# my	$NLEN	=20;		# length to pad left index numbers

sub new {
  my ($c, %o) =@_;
  my $s ={-name  =>''		# file name
	 ,-mode  =>O_CREAT|O_RDWR
	 ,-parent=>undef	# parent object
	#,-table =>undef	# data table description
	 ,-handle=>undef	# tied object ref
	#,-data  =>undef	# tied data hash ref
	#,-new   =>undef	# new file created
	#,-fh    =>undef	# file handle
	 ,-lock  =>LOCK_UN	# lock level
	 ,-lcks  =>{}		# locks
	 ,-pair  =>[]		# current key/value
         };
  foreach my $k (keys(%o)) {$s->{$k} =$o{$k}}
  bless $s, $c;
  $s->open if defined($s->{-name}) && $s->{-name} ne '';
  $s
}


sub set {
 return(keys(%{$_[0]})) if scalar(@_) ==1;
 return($_[0]->{$_[1]}) if scalar(@_) ==2;
 my ($s, %o) =@_;
 foreach my $k (keys(%o)) {$s->{$k} =$o{$k}};
 $s
}


sub parent {
 $_[0]->{-parent}
}


sub open {
 eval('use DB_File');
 my $s =shift;
 if    (!@_) {}
 elsif ($_[0] =~/^-(name|mode)$/) {$s->set(@_)}
 else  {foreach my $k ('-mode','-name') {$s->{$k} =shift if defined($_[0])}}

 my %hash;
 my $par =eval('new DB_File::BTREEINFO');
 if ($s->{-table} && $s->{-table}->{-keycmp}) {
    my $t =$s->{-table}->{-keycmp};
    $par->{'compare'} =sub{&t($s, map {[map {m/^ *(.*)$/ ? $1 : $_} split /\x00/, $_]} @_)}
                                  # see keyUnescape below
 }
 $s->{-new}    =!-e $s->{-name};
 $s->{-handle} =tie %hash, 'DB_File', $s->{-name}, $s->{-mode}, 0x666, $par;
 $s->{-data}   =\%hash;
 $s->{-lcks}   ={};

 if (!$s->{-handle}) {
    $s->{-handle} =$s->{-data} =undef;
    return(&{$s->{-parent} ? $s->{-parent}->{-die} : \&die}
           ("DBFile: open('" .($s->{-mode}||'') ."','" .($s->{-name}||'') ."') -> $!") ||undef)
 }
 $s
}


sub opent {
 return($_[0]) if $_[0]->{-handle};
 $_[0]->open || return(undef);
 $_[0]->lock($_[0]->{-lock}) if $_[0]->{-lock} ne LOCK_UN;
 $_[0]
}


sub close {
 return($_[0]) if !$_[0]->{-handle};
 $_[0]->lock(LOCK_UN) if $_[0]->{-lock} ne LOCK_UN;
 close($_[0]->{-fh})  if $_[0]->{-fh};
 my $h =$_[0]->{-data};
 $_[0]->{-data}   =undef;
 $_[0]->{-handle} =undef;
 $_[0]->{-fh}     =undef;
 $_[0]->{-lcks}   ={};
#eval {untie %$h}; # warning if another reference exists
 $_[0]
}


sub destroy {
 eval{$_[0]->close} if $_[0]->{-handle};
 $_[0]->{-parent} =undef;
 $_[0]->{-table}  =undef;
 $_[0]
}


sub DESTROY {
 destroy(@_)
}


sub lock  { # lock value, ?lock key
 # LOCK_SH ==1; LOCK_EX ==2, or LOCK_UN ==8, LOCK_NB ==4 
 return($_[0]->{-lock}) if !defined($_[1]);
 my $l =!$_[1] ? LOCK_UN : $_[1];
 my $lv=$l | LOCK_NB ^ LOCK_NB;
 if (!$_[0]->{-fh} && !CORE::open($_[0]->{-fh} =Symbol::gensym, '+<&=' .$_[0]->{-handle}->fd)) {
    $_[0]->{-fh} =undef;
    return(&{$_[0]->{-parent} ? $_[0]->{-parent}->{-die} : \&die}
           ("DBFile: open('+<&=','" .($_[0]->{-name}||'') ."') -> $!") ||undef)
 }
 if ($_[0]->{-lock} ne $lv) {
    $_[0]->{-handle}->sync;
    if ($lv eq LOCK_UN) {
       CORE::flock($_[0]->{-fh}, $_[0]->{-lock} =LOCK_UN);
       if (!defined($_[2])) { $_[0]->{-lcks} ={} }
       else                 { delete $_[0]->{-lcks}->{$_[2]} }
       $l =0; map {$l =$_ if $l <$_} values %{$_[0]->{-lcks}};
       $_[0]->{-lock} =$lv =$l if $l && CORE::flock($_[0]->{-fh}, $l);
    }
    else {
       CORE::flock($_[0]->{-fh}, $_[0]->{-lock} =LOCK_UN);
       $_[0]->{-lock} =$lv if CORE::flock($_[0]->{-fh}, $l);
    }
    $_[0]->{-handle}->sync;
 }
 if    (!defined($_[2]))	{ $_[0]->{-lcks} ={} }
 elsif ($lv eq LOCK_UN
    ||  $_[0]->{-lock} ne $lv )	{ delete $_[0]->{-lcks}->{$_[2]} }
 else				{ $_[0]->{-lcks}->{$_[2]} =$lv }
 $_[0]->{-lock} eq $lv ? $_[0] : undef
}



sub keyGet {
 return($_[0]->{-pair}->[1]) if @_ <2;
 my $v; $_[0]->{-handle}->get($_[1], $v) ? undef : $v
}


sub keyPut {
 $_[0]->{-handle}->put($_[1], $_[$#_])
 ? (&{$_[0]->{-parent} ? $_[0]->{-parent}->{-die} : \&die}
    ("DBFile: keyPut('" .($_[0]->{-name}||'') ."','" .$_[1] ."') -> $!") ||undef)
 : (@_ >3) && ($_[1] ne $_[2]) && $_[0]->{-handle}->del($_[2])
 ? (&{$_[0]->{-parent} ? $_[0]->{-parent}->{-die} : \&die}
    ("DBFile: keyDel('" .($_[0]->{-name}||'') ."','" .$_[2] ."') -> $!") ||undef)
 : $_[$#_]
}


sub keyDel {
 $_[0]->{-handle}->del(@_[1..$#_]) ? undef : $_[0]
}


sub keyFind {
 my ($s, $k, $v) =@_; 
 $s->{-handle}->seq($k, $v, R_CURSOR()) ? undef : (@{$s->{-pair}}[1,0]=($k,$v))[0]
}


sub keyFirst {
 my ($s, $k, $v) =@_; 
 $s->{-handle}->seq($k, $v, R_FIRST())  ? undef : (@{$s->{-pair}}[1,0]=($k,$v))[0]
}


sub keyLast {
 my ($s, $k, $v) =@_;
 $s->{-handle}->seq($k, $v, R_LAST())   ? undef : (@{$s->{-pair}}[1,0]=($k,$v))[0]
}


sub keyPrev {
 my ($s, $k, $v) =@_;
 $s->{-handle}->seq($k, $v, R_PREV())   ? undef : (@{$s->{-pair}}[1,0]=($k,$v))[0]
}


sub keyNext {
 my ($s, $k, $v) =@_;
 $s->{-handle}->seq($k, $v, R_NEXT())   ? undef : (@{$s->{-pair}}[1,0]=($k,$v))[0]
}


sub krEscape {
 join "\x00"
 ,map {	my $v =$_; 
	return('') if !defined($v);		# !!! lost undefined values
	$v =~s/^ *(.*?) *$/$1/;			# !!! lost extra blanks
      # $v =~s/\000/\\000/g;			# !!! key compare problem
	$v =~s/\000//g;				# !!! lost \x00 chars
	$v =' ' x ($NLEN -length($v)) .$v 	# !!! $NLEN-sign numbers
	   if $v =~/^[\d .,]+$/m && length($v) <$NLEN;
	$v
      } @{$_[1]}
}


sub krEscapeMv {
 my $r =[''];
 foreach my $v (@{$_[1]}) {
   if    (!ref($v)) {
       $v ='' if !defined($v);			# !!! lost undefined values
       $v =~s/^ *(.*?) *$/$1/;			# !!! lost extra blanks
       $v =~s/\000//g;				# !!! lost \x00 chars
       $v =' ' x ($NLEN -length($v)) .$v	# !!! $NLEN-sign numbers
          if $v =~/^[\d .,]+$/m && length($v) <$NLEN;
       map {$_ .=$v ."\x00"} @$r
   }
   elsif (ref($v) eq 'ARRAY') {
     my $r0 =$r; $r =[];
     my $a  =$v;
     foreach my $k (@$a) {
       foreach my $e (@{krEscapeMv($_[0],$k)}) {
         foreach my $v (@$r0) { push @$r, "$v$e\x00" }
       }
     }
   }
   elsif (ref($v) eq 'HASH') {
     my $r0 =$r; $r =[];
     my $h  =$v;
     foreach my $k (keys %$h) {
       my $v =$k;
       $v ='' if !defined($v);		# !!! lost undefined values
       $v =~s/^ *(.*?) *$/$1/;		# !!! lost extra blanks
       $v =~s/\000//g;			# !!! lost \x00 chars
       foreach my $e (@{krEscapeMv($_[0], $h->{$k})}) {
         foreach my $v (@$r0) { push @$r, $v . "$k=>$e\x00" }
       }
     }
   }
 }
 map {chop $_} @$r;
 $r
}


sub krUnescape {
	[map {m/^ *(.*)$/ ? $1 : $_} split /\x00/, $_[$#_]]
}


sub klUnescape {
	map {m/^ *(.*)$/ ? $1 : $_} split /\x00/, $_[$#_]
}


sub hrEscape {		# freeze($_[$#_])
	ref($_[$#_]) ne 'ARRAY'
	? '{' .join(','
		, map {	my ($k, $v) =($_, $_[$#_]->{$_});
			$k =~s/([,=%\\\]\[\{\}])/sprintf("\\x%02x",ord($1))/eg;
			if	(ref($v)) {$v =hrEscape($v)}
			else	{$v =~s/([,=%\\\]\[\{\}])/sprintf("\\x%02x",ord($1))/eg}
			"$k=$v"
			} grep {defined($_[$#_]->{$_})
				} keys %{$_[$#_]}) .'}'
	: '[' .join(','
		, map {	my $k =$_;
			$k =~s/([,=%\\\]\[\{\}])/sprintf("\\x%02x",ord($1))/eg;
			$k
			} grep {defined($_)
				} @{$_[$#_]}) .']'
}

sub hrUnescape {	# thaw($_[$#_])
	$_[$#_] =~/^\{/ ? {hlUnescape(@_)} : $_[$#_] =~/^\[/ ? [hlUnescape(@_)] : $_[$#_]
}

sub hlUnescape {	# %{thaw($_[$#_])}
 if (ref($_[$#_])) {
	my $k;
	while ($k =each %{$_[$#_]}) {$_[$#_]->{$k} =undef};
	$k =undef;
	foreach (split / *[,=] */, ($_[$#_-1] =~/^[\{\[]/ ? substr($_[$#_-1], 1, -1) : $_[$#_-1])) {
			/^\[\{\[]/
			? hrUnescape($_[0], $_)
			: s/\\x([0-9a-fA-F]{2})/chr hex($1)/eg;
		if ($k)	{$_[$#_]->{$k} =$_; $k =undef}
		else	{$k =$_}
	}
	$_[$#_];
 }
 else {	
	$_[$#_] =~/^[\{\[]/
	? (map {	/^\[\{\[]/
			? hrUnescape($_[0], $_)
			: s/\\x([0-9a-fA-F]{2})/chr hex($1)/eg;
		} split / *[,=] */, substr($_[$#_], 1, -1))
	: ($_[$#_])
 }	
}


sub keGet {
 return($_[0]->{-pair}->[1]) if @_ <2;
 my $v; $_[0]->{-handle}->get(krEscape($_[0], $_[1]), $v) ? undef : hrUnescape($v)
}


sub kePut {
 my $r =0;
 my $d =hrEscape($_[$#_]);
 if (@_ >3) {
	my $kn =krEscapeMv($_[0], $_[1]);
	my $ko =krEscapeMv($_[0], $_[2]);
	foreach my $k (@$kn) {
		$_[0]->{-handle}->put($k, $d)
		&& (&{$_[0]->{-parent} ? $_[0]->{-parent}->{-die} : \&die}
		("DBFile: kePut('" .($_[0]->{-name}||'') ."','$k') -> '$!'") ||undef);
		$r +=1;
	}
	foreach my $k (grep {my $v =$_; !grep {$v eq $_} @$kn} @$ko) {
		$_[0]->{-handle}->del($k)
	}
 }
 else {
	foreach my $k (@{krEscapeMv($_[0], $_[1])}) {
		$_[0]->{-handle}->put($k, $d)
		&& (&{$_[0]->{-parent} ? $_[0]->{-parent}->{-die} : \&die}
		("DBFile: kePut('" .($_[0]->{-name}||'') ."','$k') -> '$!'") ||undef);
		$r +=1;
	}
 }
 $r
}


sub keDel {
 my $r =0;
 foreach my $k (@{krEscapeMv($_[0], $_[1])}) {
    $_[0]->{-handle}->del($k) ||($r +=1)
 }
 $r ||undef
}



sub keSeek {
 my ($s, $flg, $sca, $subf, $subw) =@_;
    # dir/cmp, keyArray, subFilter, subEval
 my $p   =$s->parent;
 my $val =undef;
 my $dbh =$s->{-handle};
 my $dbs =0;
 my @kds =map {!ref($_) ? $_ : $_->[0]} @{$s->{-table}->{-key}} # , '_rid'
          if $s->{-table} && $s->{-table}->{-key};
 my ($r, $k) =({}, []); # record hash & key array refs
 my $ca  =0;
 my $subr=sub{undef};

 foreach my $sck (@{$s->krEscapeMv($sca)}) {
   my $key =$sck;
   my $scl =length($sck);
   if    ($flg =~/^-*[af]eq/i)    { # forward  eq
         $dbs =$dbh->seq($key, $val, R_CURSOR());
         $subr=sub{do {	return(undef) unless !$dbs && (defined($key) ? $sck eq substr($key, 0, $scl) : 0);
			$r =hlUnescape($s, $val, $r);
			@$k=klUnescape($s, $key);
			@$r{@kds}=@{$k} if @kds && !@$r{@kds};
			$dbs     =$dbh->seq($key, $val, R_NEXT());
		} while  ($subf && !&$subf($s, $k, $r))
		     ||  ($subw && ++$ca && &$subw($s, $k, $r));
	  	$r }
   }
   elsif ($flg =~/^-*[af]g[te]/i) { # forward  g[te]
         $key .="\x01" if $flg =~/gt$/i;
	 $dbs =$dbh->seq($key, $val, R_CURSOR());
         $subr=sub{do {	return(undef) unless !$dbs;
			$r =hlUnescape($s, $val, $r);
			@$k=klUnescape($s, $key);
			@$r{@kds}=@{$k} if @kds && !@$r{@kds};
			$dbs     =$dbh->seq($key, $val, R_NEXT());
		} while  ($subf && !&$subf($s, $k, $r))
		     ||  ($subw && ++$ca && &$subw($s, $k, $r));
	  	$r }
   }
   elsif ($flg =~/^-*[af]l[te]/i) { # forward  l[te]
	 $dbs =$dbh->seq($key, $val, R_FIRST());
         $subr=sub{do {	return(undef) unless !$dbs
			&& (!defined($key) ? 0 
  			   :  $flg=~/lt$/i ? $sck lt substr($key, 0, $scl) 
  					   : $sck le substr($key, 0, $scl));
			$r =hlUnescape($s, $val, $r);
			@$k=klUnescape($s, $key);
			@$r{@kds}=@{$k} if @kds && !@$r{@kds};
			$dbs     =$dbh->seq($key, $val, R_NEXT());
		} while  ($subf && !&$subf($s, $k, $r))
		     ||  ($subw && ++$ca && &$subw($s, $k, $r));
	  	$r }
   }
   elsif ($flg =~/^-*[af]all/i) {   # forward  all
	 $dbs =$dbh->seq($key, $val, R_FIRST());
         $subr=sub{do {	return(undef) unless !$dbs;
			$r =hlUnescape($s, $val, $r);
			@$k=klUnescape($s, $key);
			@$r{@kds}=@{$k} if @kds && !@$r{@kds};
			$dbs     =$dbh->seq($key, $val, R_NEXT());
		} while  ($subf && !&$subf($s, $k, $r))
		     ||  ($subw && ++$ca && &$subw($s, $k, $r));
	  	$r }
   }
   elsif ($flg =~/^-*[bd]eq/i)    { # backward eq
         $key .="\x01";
         $dbs =$dbh->seq($key, $val, R_CURSOR());
	 $dbs =$dbh->seq($key, $val, R_PREV());
         $subr=sub{do {	return(undef) unless !$dbs
			&& (defined($key) ? $sck eq substr($key, 0, $scl) : 0);
			$r =hlUnescape($s, $val, $r);
			@$k=klUnescape($s, $key);
			@$r{@kds}=@{$k} if @kds && !@$r{@kds};
			$dbs     =$dbh->seq($key, $val, R_PREV())
		} while  ($subf && !&$subf($s, $k, $r))
		     ||  ($subw && ++$ca && &$subw($s, $k, $r));
	  	$r }
   }
   elsif ($flg =~/^-*[bd]l[te]/i) { # backward l[te]
         $key .="\x01" if $flg =~/le$/i;
         $dbs =$dbh->seq($key, $val, R_CURSOR());
	 $dbs =$dbh->seq($key, $val, R_PREV());
         $subr=sub{do {	return(undef) unless !$dbs;
			$r =hlUnescape($s, $val, $r);
			@$k=klUnescape($s, $key);
			@$r{@kds}=@{$k} if @kds && !@$r{@kds};
			$dbs     =$dbh->seq($key, $val, R_PREV())
		} while  ($subf && !&$subf($s, $k, $r))
		     ||  ($subw && ++$ca && &$subw($s, $k, $r));
	  	$r }
   }
   elsif ($flg =~/^-*[bd]g[te]/i) { # backward g[te]
	 $dbs =$dbh->seq($key, $val, R_LAST());
         $subr=sub{do {	return(undef) unless !$dbs
			&& (!defined($key) ? 0 
  			   :  $flg=~/gt$/i ? $sck gt substr($key, 0, $scl) 
  					   : $sck ge substr($key, 0, $scl));
			$r =hlUnescape($s, $val, $r);
			@$k=klUnescape($s, $key);
			@$r{@kds}=@{$k} if @kds && !@$r{@kds};
			$dbs     =$dbh->seq($key, $val, R_PREV())
		} while  ($subf && !&$subf($s, $k, $r))
		     ||  ($subw && ++$ca && &$subw($s, $k, $r));
	  	$r }
   }
   elsif ($flg =~/^-*[bd]all/i) {   # backward all
	 $dbs =$dbh->seq($key, $val, R_LAST());
         $subr=sub{do {	return(undef) unless !$dbs;
			$r =hlUnescape($s, $val, $r);
			@$k=klUnescape($s, $key);
			@$r{@kds}=@{$k} if @kds && !@$r{@kds};
			$dbs     =$dbh->seq($key, $val, R_PREV())
		} while  ($subf && !&$subf($s, $k, $r))
		     ||  ($subw && ++$ca && &$subw($s, $k, $r));
	  	$r }
   }
 }
 $subr =DBIx::Web::dbmCursor->new($subr, -rec=>$r, -key=>$k);
 if ($subw) {$subr->call; $subr =$ca};
 $subr
}


sub keScan {
 &{shift->parent->{-die}}("DBFile: 'keScan' not implemented yet!")
}



#########################################################
# Condition code block object, use isa($object,'CODE') !
#########################################################


package DBIx::Web::ccbHandle;
use strict;

sub new {
  my ($c, $e) =@_;
  if (!ref($e)) { # string to safe evaluate
     my $c =$e;
     my $m =eval('use Safe; Safe->new()');
     #  $m->permit_only(qw(recSel recRead fetch fetchrow_arrayref fetchrow_hashref :default)); # may be :base_core :browse
	$m->permit_only(qw(:default :base_core :browse));
        $m->share('@_', '$DBIx::Web::SELF');
     my $o =$DBIx::Web::SELF;
     $e =sub{	local ($DBIx::Web::SELF, $^W) =($o, undef);
		$m->reval($c)};
  }
  bless $e, $c;
  $e
}


sub call { &{$_[0]}(@_[1..$#_]) }

sub fetch{ &{$_[0]}(@_[1..$#_]) }

sub eval { CORE::eval{&{$_[0]}(@_[1..$#_])} }



#########################################################
# DBM Cursor object
#########################################################


package DBIx::Web::dbmCursor;
use strict;

sub new {
  my ($c, $e) =@_;
  my $s={''=>$e, -rfl=>undef, @_[2..$#_]};
	# -rec=>{}, -key=>[], -rfr=>[];
  bless $s, $c;
  $s
}

sub setcols {
 $_[0]->{NAME_db} =[map {!ref($_) ? $_ : ref($_) ne 'HASH' ? $_->[0] : (defined($_->{-expr}) ? $_->{-expr} : $_->{-fld})} ref($_[1]) ? @{$_[1]} : @_[1..$#_]];
 $_[0]->{NAME}	  =[map {!ref($_) ? $_ : ref($_) ne 'HASH' ? $_->[1] : $_->{-fld}} ref($_[1]) ? @{$_[1]} : @_[1..$#_]];
 $_[0]->{-rfr}	  =[map {$_[0]->{-rec}->{$_} =undef if !exists($_[0]->{-rec}->{$_});
			 \($_[0]->{-rec}->{$_})
			} @{$_[0]->{NAME_db}}] if $_[0]->{-rec};
 $_[0]->{-rfl}	  =[];	# record fields list
 $_[0]
}

sub call { 
	&{$_[0]->{''}}(@_[1..$#_])
}

sub eval { 
	CORE::eval{&{$_[0]->{''}}(@_[1..$#_])}
}

sub fetch { 
	my $v =&{$_[0]->{''}}(@_[1..$#_]);
	if ($v) {@{$_[0]->{-rfl}} =map {$$_} @{$_[0]->{-rfr}}; $_[0]->{-rfl}}
	else	{@{$_[0]->{-rfl}} =(); undef}
}

sub fetchrow_arrayref {
	my $v =&{$_[0]->{''}}(@_[1..$#_]);
	if ($v) {@{$_[0]->{-rfl}} =@${v}{@{$_[0]->{NAME_db}}}; $_[0]->{-rfl}}
	else	{@{$_[0]->{-rfl}} =(); undef}
}

sub fetchrow_hashref {
	$_[0]->{-rec} =&{$_[0]->{''}}(@_[1..$#_]);
}

sub finish {
 $_[0]->{''} =undef;
}

sub close {
 $_[0]->{''} =undef;
}


#########################################################
# DBI Cursor object implementing filtering sub{}
#########################################################


package DBIx::Web::dbiCursor;
use strict;
use vars qw($AUTOLOAD);

sub new {
  my ($c, $i) =@_;
  my $s={''=>$i, @_[2..$#_]};
	# -rec=>{}, -rfr=>[], -flt=>sub{};
  bless $s, $c;
  $s
}


sub fetch { 
	my ($r, $k);
	while (1) {
		while ($k = each %{$_[0]->{-rec}}) {$_[0]->{-rec}->{$k} =undef};
		$r =$_[0]->{''}->fetch(@_[1..$#_]);
		last	if !$r || !$_[0]->{-flt} 
			|| &{$_[0]->{-flt}}($_[0],undef,$_[0]->{-rec})
	}
	$r
}

sub fetchrow_arrayref {
	my ($r, $k);
	while (1) {
		while ($k = each %{$_[0]->{-rec}}) {$_[0]->{-rec}->{$k} =undef};
		$r =$_[0]->{''}->fetchrow_arrayref(@_[1..$#_]);
		last	if !$r || !$_[0]->{-flt} 
			|| &{$_[0]->{-flt}}($_[0],undef,$_[0]->{-rec})
	}
	$r
}

sub fetchrow_hashref {
	my ($r, $k);
	while (1) {
		while ($k = each %{$_[0]->{-rec}}) {$_[0]->{-rec}->{$k} =undef};
		$r =$_[0]->{''}->fetchrow_hashref(@_[1..$#_]);
		last	if !$r || !$_[0]->{-flt} 
			|| &{$_[0]->{-flt}}($_[0],undef,$_[0]->{-rec})
	}
	$r
}


sub finish {
 $_[0]->{''}->finish(@_[1..$#_])
}


sub close {
	eval {$_[0]->{''}->finish(@_[1..$#_])};
	$_[0]->{''}=undef;
}


sub AUTOLOAD {
	my $m =substr($AUTOLOAD, rindex($AUTOLOAD, '::')+2);
	confess("!object in AUTOLOAD of $AUTOLOAD") if !ref($_[0]);
	$_[0]->{''}->$m(@_[1..$#_])
}