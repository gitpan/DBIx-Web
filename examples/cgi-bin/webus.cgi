#!perl -w
#http://localhost/cgi-bin/cgi-bus/webus.cgi
BEGIN {
#push @INC, $1 .'sitel/lib' if !(grep /sitel/i, @INC) && ($INC[0] =~/(.+?[\\\/])lib$/i);
}
#$ENV{HTTP_ACCEPT_LANGUAGE} ='';
my $wsdir =$^O eq 'MSWin32' ? Win32::GetFullPathName($0) : $0;
   $wsdir =~s/\\/\//g;
   $wsdir =	  $wsdir =~/^(\w:\/inetpub)\//i
		? $1
		: $wsdir =~/\/cgi-bin\//i
		? $`
		: $ENV{DOCUMENT_ROOT} && $ENV{DOCUMENT_ROOT} =~/[\\\/]htdocs/i
		? $`
		: '../';
   $wsdir =	  $wsdir =~/^(\w:\/inetpub)\//i ? "$wsdir/wwwroot" : "$wsdir/htdocs";

use DBIx::Web;
my $w =DBIx::Web->new(
  -title	=>'DBIx-WeBus'	# title of application
#,-logo		=>'<img src="/icons/p.gif" border="0" />'
 ,-debug	=>2		# debug level
 ,-serial	=>2		# serial operation level
 ,-dbiarg	=>["DBI:mysql:cgibus","cgibus","d83nfmJR971Yv3gVI35"]
#,-dbiph	=>1		# dbi placeholders usage
 ,-dbiACLike	=>'eq'		# dbi access control comparation, i.e. 'eq lc'
 ,-keyqn	=>1		# key query null comparation
 ,-path		=>"$wsdir/dbix-web"	# datastore path
 ,-cgibus	=>"$wsdir/cgi-bus"	# legacy mode
 ,-url		=>'/cgi-bus'	# filestore URL
 ,-urf		=>'-path'	# filestore filesystem URL
#,-fswtr	=>''		# filesystem writers (default is process account)
#,-AuthUserFile	=>''		# apache users file
#,-AuthGroupFile=>''		# apache groups file
#,-login	=>/cgi-bin/ntlm/# login URL
#,-userln	=>0		# short local usernames (0==off, 1==default)
 ,-ugadd	=>['Everyone','Guests']		# additional user groups
#,-rac		=>0		# record access control (0==off, 1==default)
#,-racAdmRdr	=>''		# record access control admin reader
#,-racAdmWtr	=>''		# record access control admin writer
#,-rfa		=>0		# record file attachments (0==off, 1==default)
#,-httpheader	=>{}		# http header arguments
#,-htmlstart	=>{}		# html start arguments
 ,-setall	=>1		# full features on
#,-smtphost	=>'localhost'	# smtp mail server
#,-smtpdomain	=>'localhost'	# smtp default domain
 );

$w->set(
  -table	=>{
   'notes'=>{
	 -lbl		=>'Notes'
	,-cmt		=>'Notes'
	,-lbl_ru	=>'Заметки'
	,-cmt_ru	=>'Заметки'
	,-expr		=>'cgibus.notes'
	,-null		=>''
	,-field		=>[
		 {-fld=>$w->tn('-rvcActPtr')
			,-flg=>'q'
			,-hide=>sub{!$_}
			},
		,{-fld=>'id'
			,-flg=>'kwq'
			,-lblhtml=>$w->tfoShow('id_',['idrm'])
			}, ''
		,{-fld=>$w->tn('-rvcInsWhen')
			,-flg=>'q'
			}, ''
		,{-fld=>$w->tn('-rvcInsBy')
			,-flg=>'q'
			}, 
		,{-fld=>'idrm'
			,-flg=>'euq'
			,-hide=>$w->tfoHide('id_')
			},''
		,{-fld=>$w->tn('-rvcUpdWhen')
			,-flg=>'wql'
			,-ldstyle=>'width: 25ex'
			,-ldprop=>'nowrap=true'
			},''
		,{-fld=>$w->tn('-rvcUpdBy')
			,-edit=>0
			,-flg=>'wql'
			,-lhstyle=>'width: 10ex'
			}
		,{-fld=>'prole'
			,-flg=>'euq'
			,-ddlb=>sub{$_[0]->uglist({})}
			#,-ddlbtgt=>[[undef,undef,','],['rrole',undef,',']]
			,-ddlbtgt=>[[undef,undef],['rrole',undef]]
			}, ''
		,{-fld=>'rrole'
			,-flg=>'euq'
			,-ddlb=>sub{$_[0]->uglist({})}
			,-colspan=>3
			 }
		,$w->{-setall}
		? {-fld=>'mailto'
			,-flg=>'euq'
			,-ddlb=>sub{$_[0]->uglist({})}
			,-ddlbtgt=>[[undef,undef,', ']]
			,-ddlbmsab=>1
			 }
		: ()
		,{-fld=>$w->tn('-rvcState')
			,-inp=>{-values=>['ok','edit','chk-out','deleted']
				,-labels_ru=>{'ok'=>'завершено','edit'=>'редакт-е','deleted'=>'удалено'}
				# ,-loop=>1
				}
			,-flg=>'euql', -null=>undef
			,-lhstyle=>'width: 5ex'
			,-ldstyle=>sub{	/^(?:ok)$/
					? '' : 'color: red; font-weight: bold'}
			}, ''
		,{-fld=>'subject'
			,-flg=>'euqlm', -null=>undef
			,-inp=>{-asize=>60}
			#,-ddlb=>[[1,'one'],2,3,'qw']
			,-colspan=>3
			}
		,"\f"
		,{-fld=>'comment'
			,-flg=>'eu'
			,-lblhtml=>'' # '<b>$_</b><br />'
			,-inp=>{-htmlopt=>1, -hrefs=>1, -arows=>5, -cols=>70}
			}
		,$w->tfsAll() # ,$w->tfdRFD(),$w->tfvVersions(),$w->tfvReferences()		
		]
		,$w->ttoRVC()
		,-racReader	=>[qw(rrole)]
		,-racWriter	=>[$w->tn('-rvcUpdBy'), $w->tn('-rvcInsBy'), 'prole']
		,-ridRef	=>[qw(idrm comment)]
		,-rfa		=>1
		,-recNew0C	=>sub{	$_[2]->{'idrm'} =$_[3]->{'id'}||'';
					foreach my $n (qw(prole rrole)) {
						$_[2]->{$n} =$_[3]->{$n} 
							if !$_[2]->{$n} && $_[3]->{$n};
						$_[0]->recLast($_[1],$_[2],['uuser'],[$n])
							if !$_[2]->{$n};
					}
					$_[2]->{'status'} ='ok' if !$_[2]->{'status'};
				}
		,-recChg0R	=>sub {
				$_[0]->smtpSend(-to=>$_[2]->{mailto}
						,-pout=>$_[2], -pcmd=>$_[1])
					if $_[2]->{mailto}
					&& ($_[2]->{$_[0]->tn('-rvcState')}
						=~/^(?:ok|no|do|progress|deleted)$/);
				}
		,-query		=>{	 -keyord=>'-dall'
					,-order=>'utime'
				#	,-frmLso=>['author','hierarchy']
					}
		,-frmLsoAdd	=>
				[['hierarchy',undef,{-qkeyadd=>{'idrm'=>undef}}]
				]
		,-dbd		=>'dbi'
	}
  ,'gwo'=>{
	 -lbl		=>'Organizer'
	,-cmt		=>'Groupware organizer'
	,-lbl_ru	=>'Органайзер'
	,-cmt_ru	=>'Коллективный органайзер'
	,-expr		=>'cgibus.gworganizer'
	,-null		=>''
	,-field		=>[
		 {-fld=>$w->tn('-rvcActPtr')
			,-flg=>'q'
			,-hide=>sub{!$_}
			},
		,{-fld=>'id'
			,-flg=>'kwq'
			,-lblhtml=>$w->tfoShow('id_',['idrm','idrr','idpr'])
			}, ''
		,{-fld=>$w->tn('-rvcInsWhen')
			,-flg=>'q'
			,-lhstyle=>'width: 25ex'
			}, ''
		,{-fld=>$w->tn('-rvcInsBy')
			,-flg=>'q'
			}, "\n\t\t"
		,{-fld=>$w->tn('-rvcUpdWhen')
			,-flg=>'wq'
			,-lhstyle=>'width: 25ex'
			},''
		,{-fld=>$w->tn('-rvcUpdBy')
			,-edit=>0
			,-flg=>'wq'
			,-lhstyle=>'width: 10ex'
			}
		,{-fld=>'idrm'
			,-flg=>'euq'
			,-hide=>$w->tfoHide('id_')
			},''
		,0 && $w->{-setall}
		?({-fld=>'idrr'		# !!! unimplemented, needed?
			,-flg=>'euq'
			,-hide=>$w->tfoHide('id_')
			},'')
		:()
		,{-fld=>'idpr'
			,-flg=>'euq'
			,-hide=>$w->tfoHide('id_')
			}
		,{-fld=>'puser'
			,-flg=>'euq'
			,-ddlb=>sub{$_[0]->uglist({})}
			#,-ddlb=>sub{$_[0]->uglist('-ug',$_[0]->{-pdta}->{'prole'},{})}
			,-ddlbtgt=>[undef,['prole'],['auser'],['arole'],['rrole'],['mailto',undef,',']]
			}, ''
		,{-fld=>'prole'
			,-flg=>'euq'
			,-ddlb=>sub{$_[0]->uglist({})}
			#,-ddlb=>sub{$_[0]->uglist('-g',$_[0]->{-pdta}->{'puser'},{})}
			,-ddlbtgt=>[undef,['puser'],['auser'],['arole'],['rrole'],['mailto',undef,',']]
			,-colspan=>3
			}
		,{-fld=>'auser'
			,-flg=>'euql'
			,-ddlb=>sub{$_[0]->uglist({})}
			#,-ddlb=>sub{$_[0]->uglist('-ug',$_[0]->{-pdta}->{'arole'},{})}
			,-ddlbtgt=>[undef,['puser'],['prole'],['arole'],['rrole'],['mailto',undef,',']]
			}, ''
		,{-fld=>'arole'
			,-flg=>'euql'
			,-ddlb=>sub{$_[0]->uglist({})}
			#,-ddlb=>sub{$_[0]->uglist('-g',$_[0]->{-pdta}->{'auser'},{})}
			,-ddlbtgt=>[undef,['puser'],['prole'],['auser'],['rrole'],['mailto',undef,',']]
			,-colspan=>3
			}
		,{-fld=>'rrole',
			,-flg=>'euq'
			,-ddlb=>sub{$_[0]->uglist({})}
			,-ddlbtgt=>[undef,['puser'],['prole'],['auser'],['arole'],['mailto',undef,',']]
			 }
		,$w->{-setall}
		?(''
		 ,{-fld=>'mailto'
			,-flg=>'euq'
			,-ddlb=>sub{$_[0]->uglist({})}
			,-ddlbtgt=>[[undef,undef,', ']]
			,-ddlbmsab=>1
			 }, ''
		 ,{-fld=>'period'
			,-flg=>'euq'
			,-lbl=>'Period',-cmt=>'Period (y,m,d,h) of Record described by'
			,-lbl_ru=>'Период', -cmt_ru=>'Периодичность (г,м,д,ч) выполнения записи'
			 })
		: ()
		,{-fld=>$w->tn('-rvcState')
			,-inp=>{-values=>$w->tn('-rvcAllState')}
			,-flg=>'euql', -null=>undef
			,-lhstyle=>'width: 5ex'
			,-ldstyle=>sub{ # my $v=$_; $v && grep(/^$v$/, @{$_[0]->{-tn}->{-rvcFinState}})
					/^(?:ok)$/
					? '' : 'color: red; font-weight: bold'}
			}, ''
		,{-fld=>'stime'
			,-flg=>'euq'
			,-lbl=>'Start', -cmt=>'Start time of record described by'
			,-lbl_ru=>'Начало', -cmt_ru=>'Дата и время начала описываемого записью'
			,-lhstyle=>'width: 25ex'
			 }, ''
		,{-fld=>'etime'
			,-flg=>'euq'
			,-lbl=>'Finish', -cmt=>'Finish time of record described by'
			,-lbl_ru=>'Заверш', -cmt_ru=>'Дата и время завершения описываемого записью'
			,-ldstyle=>'width: 25ex'
			,-ldprop=>'nowrap=true'
			 }
		,{-fld=>'ftime'
			,-flg=>'l', -hidel=>1
			,-expr=>'COALESCE(etime, utime)'
			,-lbl=>'Final', -cmt=>'Finish or last updated time of record'
			,-lbl_ru=>'Завершение', -cmt_ru=>'Дата-время завершения или последнего изменения записи'
			,-ldstyle=>'width: 25ex'
			,-ldprop=>'nowrap=true'
			 }
		,{-fld=>'record'
			,-inp=>{-values=>['', qw(note log --- incident problem experim --- object query change upgrade install move delete serve --- draft paper manual --- msg contact address)]}
			,-flg=>'euql'
			}, ''
		,{-fld=>'object'
			,-flg=>'euql'
			,-ddlb=>'gwoobj'	# sub{$_[0]->cgiQuery('gwoobj')}
		#	,-ddlbloop=>1
		#	,-form=>'gwo'
			}
		,$w->{-setall}
		?(''
		 ,{-fld=>'doctype'
			,-flg=>'euq'
			,-ddlb=>'gwodoc'
			}
		 ,"\n\t\t"
		 ,{-fld=>'project'
			,-flg=>'euq'
			,-ddlb=>'gwoprj'
			}, ''
		 ,{-fld=>'cost'
			,-flg=>'euq'
			})
		:()
		,{-fld=>'subject'
			,-flg=>'euqlm', -null=>undef
			,-inp=>{-asize=>60}
			,-colspan=>6
			}
		#,"\f"
		,{-fld=>'comment'
			,-flg=>'eu'
			#,-lblhtml=>'<b>$_</b><br />'
			,-lblhtbr =>"\f"
			,-inp=>{-htmlopt=>1, -hrefs=>1, -arows=>5, -cols=>70}
			}
		,$w->tfsAll()
		]
		,$w->ttoRVC()
		,-racPrincipal	=>['puser', 'prole']
		,-racActor	=>['auser', 'arole']
		,-racReader	=>[qw(rrole)]
		,-racWriter	=>[$w->tn('-rvcUpdBy'), $w->tn('-rvcInsBy'), 'puser', 'prole', 'auser', 'arole']
		,-ridRef	=>[qw(idrm idpr comment)]
		,-rfa		=>1
		,-recNew0C	=>sub{
				$_[2]->{'idrm'} =$_[3]->{'id'}||'';
				foreach my $n (qw(puser prole auser arole rrole object)) {
					$_[2]->{$n} =$_[3]->{$n}
						if !$_[2]->{$n} && $_[3]->{$n}
				}
				foreach my $n (qw(puser auser)) {
					$_[2]->{$n} =$_[0]->user()
						if !$_[2]->{$n}
				}
				$_[0]->recLast($_[1],$_[2],['auser'],['rrole'])
					if !$_[2]->{'rrole'};
				$_[2]->{'status'}='ok' if !$_[2]->{'status'};
			}
		,-recEdt0A	=> sub{ # $_[0]->logRec('recEdt0A',@_[1..$#_]);
				if (	$_[1]->{-cmd} eq 'recNew'
				||	$_[2]->{'puser__L'}
				||	$_[2]->{'auser__L'}) {
					$_[0]->recLast($_[1],$_[2],['puser'],['prole']);
					$_[0]->recLast($_[1],$_[2],['auser'],['arole']);
				}
			}
		,-recEdt0R	=> sub{ # $_[0]->logRec('recEdt0A',@_[1..$#_]);
				$_[2]->{stime} =$_[2]->{ctime} || $_[0]->strtime()
					if !$_[2]->{stime};
				$_[2]->{etime} =$_[2]->{utime}
					if !$_[2]->{etime}
					|| ($_[3] && $_[3]->{utime} && ($_[2]->{etime} eq $_[3]->{utime}));
				$_[2]->{stime} =(length($3) <3 ? "20$3" : $3) .'-' .$2 .'-' .$1 .$4
					if $_[2]->{stime} 
					&& $_[2]->{stime} =~/^(\d+)\.(\d+)\.(\d+)(.*)/;
				$_[2]->{etime} =(length($3) <3 ? "20$3" : $3) .'-' .$2 .'-' .$1 .$4
					if $_[2]->{etime} 
					&& $_[2]->{etime} =~/^(\d+)\.(\d+)\.(\d+)(.*)/;
				($_[2]->{etime}, $_[2]->{stime})
					= ($_[2]->{stime}, $_[2]->{etime})
					if $_[2]->{etime}
					&& $_[2]->{stime}
					&& ($_[2]->{stime} gt $_[2]->{etime});
			}
		,-recChg0R	=>sub {
				$_[0]->smtpSend(-to=>$_[2]->{mailto}
						,-pout=>$_[2], -pcmd=>$_[1])
					if $_[2]->{mailto}
					&& ($_[2]->{$_[0]->tn('-rvcState')}
						=~/^(?:ok|no|do|progress|deleted)$/);
				}
		,-recUpd0R	=>sub {	# $_[0]->logRec('recUpd0R',@_[1..$#_]);
				if ($_[2]->{period}
				&& ($_[2]->{$_[0]->tn('-rvcState')} =~/^(?:ok|no)/)
				&& ($_[3]->{$_[0]->tn('-rvcState')} !~/^(?:ok|no)/)){
					my $n ={%{$_[2]}};
					$n->{stime}=$_[0]->strtime($_[0]->timeadd($_[0]->timestr($n->{stime}), split /,;\s/, $n->{period}))
						if $n->{stime};
					$n->{etime}=$_[0]->strtime($_[0]->timeadd($_[0]->timestr($n->{etime}), split /,;\s/, $n->{period}))
						if $n->{etime};
					$n->{$_[0]->tn('-rvcState')} ='do';
					$n->{idpr} =$n->{id};
					$_[0]->recIns(-table=>'gwo'
						,-data=>$n
						,$_[1]->{-file} ? (-file=>$_[1]->{-file}) : ());
					sleep(1) if $_[0]->{-cgibus};
				}
			}
		,-query		=>{-keyord=>'-dall'
				, -order=>'ftime'
				, -data=>[qw(ftime status auser arole object subject id)]
				, -display=>[qw(ftime status object subject auser arole)]
			#	, -frmLso=>['author','hierarchy']
				}
		,-frmLsoAdd	=>
				[{-val=>'hierarchy', -cmd=>{-qkeyadd=>{'idrm'=>undef}}}
				]
		,-frmLsc	=>
				[{-val=>'ftime'}
				,['utime',undef
					,sub {	$_[3]->{-order} ='utime';
						$_[3]->{-data}->[0] 
						=$_[3]->{-display}->[0] ='utime'}]
				,['ctime',undef
					,sub {	$_[3]->{-order} ='ctime';
						$_[3]->{-data}->[0] 
						=$_[3]->{-display}->[0] ='ctime'}]
				]
		,-dbd		=>'dbi'
	}
	,!$w->{-cgibus} 
	? $w->ttsAll() # !!! materialized views not used in cgi-bus
	: ()
	});

$w->set(
   -form=>{
	 'default'	=>{-subst=>'index'}
	,$w->tvdIndex()
	,$w->tvdFTQuery()
	,1 ? ('noteshier'	=>{
		 -lbl		=>'Notes hierarchy'
		,-cmt		=>'Notes hierarchy'
		,-lbl_ru	=>'Заметки - иерархически'
		,-cmt_ru	=>'Иерархия записей заметок'
		,-table		=>'notes'
		,-query		=>{-keyord=>'-dall'
				  ,-key=>{'idrm'=>undef}
				  ,-order=>'utime'}
		#,-qfilter	=>sub{!$_[4]->{'idrm'}}
		,-frmLsoAdd	=>undef
		}) : ()
	,1 ? ('gwohier'	=>{
		 -lbl		=>'Organizer hierarchy'
		,-cmt		=>'Groupware organizer hierarchy'
		,-lbl_ru	=>'Органайзер - иерархически'
		,-cmt_ru	=>'Иерархия записей органайзера'
		,-table		=>'gwo'
		,-query		=>{-keyord=>'-dall'
				  ,-key=>{'idrm'=>undef}
				  ,-order=>'ftime'}
		,-frmLsoAdd	=>undef
		}) : ()
	,'gwoobj'	=>{
		 -lbl		=>'Organizer objects'
		,-cmt		=>'Groupware organizer objects'
		,-lbl_ru	=>'Органайзер - объекты'
		,-cmt_ru	=>'Объекты записей органайзера'
		,-table		=>'gwo'
		,-recQBF	=>'gwo'
		,-query		=>{-data	=>['object']
				  ,-display	=>['object']
				  ,-order	=>'object'
				  ,-group	=>'object'
				  ,-keyord	=>'-aall'
					}
		,-limit		=>1024*4
		,-qhref		=>{-key=>['object'], -form=>'gwo', -cmd=>'recList'}
		,-frmLsc	=>
				[{-val=>'alphabetically'}
				,['utime',undef, {-order=>'utime',-keyord=>'-dall'}]
				,['ctime',undef, {-order=>'ctime',-keyord=>'-dall'}]
				]
		}
	,$w->{-setall}
	?('gwodoc'	=>{
		 -lbl		=>'Organizer doctypes'
		,-cmt		=>'Groupware organizer document types'
		,-lbl_ru	=>'Органайзер - документы'
		,-cmt_ru	=>'Типы документов в записях органайзера'
		,-table		=>'gwo'
		,-recQBF	=>'gwo'
		,-query		=>{-data	=>['doctype']
				  ,-display	=>['doctype']
				  ,-order	=>'doctype'
				  ,-group	=>'doctype'
				  ,-keyord	=>'-aall'
					}
		,-qhref		=>{-key=>['doctype'], -form=>'gwo', -cmd=>'recList'}
		,-frmLsc	=>
				[{-val=>'alphabetically'}
				,['utime',undef, {-order=>'utime',-keyord=>'-dall'}]
				,['ctime',undef, {-order=>'ctime',-keyord=>'-dall'}]
				]
		})
	: ()
	,$w->{-setall}
	?('gwoprj'	=>{
		 -lbl		=>'Organizer projects'
		,-cmt		=>'Groupware organizer projects'
		,-lbl_ru	=>'Органайзер - проекты'
		,-cmt_ru	=>'Проекты в записях органайзера'
		,-table		=>'gwo'
		,-recQBF	=>'gwo'
		,-query		=>{-data	=>['project']
				  ,-display	=>['project']
				  ,-order	=>'project'
				  ,-group	=>'project'
				  ,-keyord	=>'-aall'
					}
		,-qhref		=>{-key=>['project'], -form=>'gwo', -cmd=>'recList'}
		,-frmLsc	=>
				[{-val=>'alphabetically'}
				,['utime',undef, {-order=>'utime',-keyord=>'-dall'}]
				,['ctime',undef, {-order=>'ctime',-keyord=>'-dall'}]
				]
		})
	: ()
	});

#$w->set(-index=>1);
#$w->set(-setup=>1);
$w->cgiRun();

##############################
# Setup Script
##############################
__END__
#
# Connect as root to mysql, once creating database and user:
#{$_->{-dbi} =undef; $_->{-dbiarg} =['DBI:mysql:mysql','root','password']; $_->dbi; <STDIN>}
#
# Reconnect as operational user, creating or upgrading tables:
#{$_->{-dbi} =undef; $_->{-dbiarg} =$_->{-dbiargpv}; $_->dbi; <STDIN>}
#
# Reindex database:
{$s->recReindex(1)}
#
#
