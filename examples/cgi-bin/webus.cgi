#!perl -w
#http://localhost/cgi-bin/cgi-bus/webus.cgi
BEGIN {
# push @INC, $1 .'sitel/lib' if !(grep /sitel/i, @INC) && ($INC[0] =~/(.+?[\\\/])lib$/i)
}
use DBIx::Web;
my $w =DBIx::Web->new(
  -debug	=>2
 ,-serial	=>2
 ,-dbiarg	=>["DBI:mysql:cgibus","cgibus","********"]
 ,-keyqn	=>1
#,-dbiph	=>1
 ,-path		=>"$ENV{DOCUMENT_ROOT}/dbix-web"
 ,-cgibus	=>"$ENV{DOCUMENT_ROOT}/cgi-bus"
 ,-url		=>'/cgi-bus'
 ,-urf		=>'-path'
#,-racAdmRdr	=>''
#,-racAdmWtr	=>''
#,-setall	=>1		# full features - under development
 );

$w->set(
  -table	=>{	 # $w->ttsAll(),
   'notes'=>{
	 -lbl		=>'Notes'
	,-cmt		=>'Notes'
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
			,-ldstyle=>'width: 20ex'
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
		? {-fld=>'mailto'	# !!! unimplemented yet
			,-flg=>'euq'
			,-ddlb=>sub{$_[0]->uglist({})}
			 }
		: ()
		,{-fld=>$w->tn('-rvcState')
			,-inp=>{-values=>['ok','edit','chk-out','deleted']}
			,-flg=>'euql', -null=>undef
			,-lhstyle=>'width: 5ex'
			}, ''
		,{-fld=>'subject'
			,-flg=>'euql', -null=>undef
			,-inp=>{-asize=>60}
			#,-ddlb=>[[1,'one'],2,3,'qw']
			,-colspan=>3
			}
		,"\f"
		,{-fld=>'comment'
			,-flg=>'eu'
			,-lblhtml=>'<b>$_</b><br />'
			,-inp=>{-htmlopt=>1, -hrefs=>1, -arows=>5, -cols=>70}
			}
		,$w->tfsAll() # ,$w->tfdRFD(),$w->tfvVersions(),$w->tfvReferences()		
		]
		,$w->ttoRVC()
		,-racReader	=>[qw(rrole)]
		,-racWriter	=>[$w->tn('-rvcUpdBy'), $w->tn('-rvcInsBy'), 'prole']
		,-ridRef	=>[qw(idrm comment)]
		,-rfa		=>1
		,-recNew0R	=>sub{	$_[2]->{'idrm'} =$_[3]->{'id'}||'';
					foreach my $n (qw(prole rrole)) {
						next if !$_[3]->{$n};
						$_[2]->{$n} =$_[3]->{$n};
					}
				}
		,-query		=>{-keyord=>'-dall', -order=>'utime desc'}
		,-dbd		=>'dbi'
	}
  ,'gwo'=>{
	 -lbl		=>'Organizer'
	,-cmt		=>'Groupware organizer'
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
			}, ''
		,{-fld=>$w->tn('-rvcInsBy')
			,-flg=>'q'
			}, "\n\t\t"
		,{-fld=>$w->tn('-rvcUpdWhen')
			,-flg=>'wq'
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
		,$w->{-setall}
		?({-fld=>'idrr'
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
			,-ddlbtgt=>[undef,['prole'],['auser'],['arole'],['rrole'],['mailto',undef,',']]
			}, ''
		,{-fld=>'prole'
			,-flg=>'euq'
			,-ddlb=>sub{$_[0]->uglist({})}
			,-ddlbtgt=>[undef,['puser'],['auser'],['arole'],['rrole'],['mailto',undef,',']]
			,-colspan=>3
			}
		,{-fld=>'auser'
			,-flg=>'euql'
			,-ddlb=>sub{$_[0]->uglist({})}
			,-ddlbtgt=>[undef,['puser'],['prole'],['arole'],['rrole'],['mailto',undef,',']]
			}, ''
		,{-fld=>'arole'
			,-flg=>'euql'
			,-ddlb=>sub{$_[0]->uglist({})}
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
		 ,{-fld=>'mailto'	# !!! unimplemented yet
			,-flg=>'euq'
			,-ddlb=>sub{$_[0]->uglist({})}
			,-ddlbtgt=>[[undef,undef,',']]
			 }, ''
		 ,{-fld=>'period'	# !!! unimplemented yet
			,-flg=>'euq'
			 })
		: ()
		,{-fld=>$w->tn('-rvcState')
			,-inp=>{-values=>$w->tn('-rvcAllState')}
			,-flg=>'euql', -null=>undef
			,-lhstyle=>'width: 5ex'
			}, ''
		,{-fld=>'stime'
			,-flg=>'euq'
			,-lbl=>'Start', -cmt=>'Start time of record described by'
			 }, ''
		,{-fld=>'etime'
			,-flg=>'euql'
			,-lbl=>'Finish', -cmt=>'Finish time of record described by'
			,-ldstyle=>'width: 20ex'
			,-ldprop=>'nowrap=true'
			 }
		,{-fld=>'record'
			,-inp=>{-values=>['', qw(note log --- incident problem experim --- object query change upgrade install move delete serve --- draft paper manual --- msg contact address)]}
			,-flg=>'euql'
			}, ''
		,{-fld=>'object'
			,-flg=>'euql'
			,-ddlb=>'gwoobj'	# sub{$_[0]->cgiQuery('gwoobj')}
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
			,-flg=>'euql', -null=>undef
			,-inp=>{-asize=>60}
			,-colspan=>6
			}
		,"\f"
		,{-fld=>'comment'
			,-flg=>'eu'
			,-lblhtml=>'<b>$_</b><br />'
			,-inp=>{-htmlopt=>1, -hrefs=>1, -arows=>5, -cols=>70}
			}
		,$w->tfsAll()
		# !!! sorting computed fields
		]
		,$w->ttoRVC()
		,-racPrincipal	=>['puser', 'prole']
		,-racActor	=>['auser', 'arole']
		,-racReader	=>[qw(rrole)]
		,-racWriter	=>[$w->tn('-rvcUpdBy'), $w->tn('-rvcInsBy'), 'puser', 'prole', 'auser', 'arole']
		,-ridRef	=>[qw(idrm idpr comment)]
		,-rfa		=>1
		,-recNew0R	=>sub{	$_[2]->{'idrm'} =$_[3]->{'id'}||'';
					foreach my $n (qw(puser prole auser arole rrole object)) {
						next if !$_[3]->{$n};
						$_[2]->{$n} =$_[3]->{$n};
					}
					foreach my $n (qw(puser auser)) {
						$_[2]->{$n} =$_[0]->user()
							if !$_[2]->{$n}
					}
					$_[2]->{'stime'} =$_[0]->strtime();
				}
		,-query		=>{-keyord=>'-dall'
				, -order=>'etime desc'
				, -data=>[qw(etime status auser arole object subject id)]
				, -display=>[qw(etime status object subject auser arole)]
				}
		,-dbd		=>'dbi'
	}
	,!$w->{-cgibus} ? $w->ttsAll() : () # materialized views not used in cgi-bus
	});

$w->set(
   -form=>{
	 'default'	=>{-subst=>'index'}
	,$w->tvdIndex()
	,$w->tvdFTQuery()
	,'noteshier'	=>{
		 -lbl		=>'Notes hierarchy'
		,-cmt		=>'Notes hierarchy'
		,-table		=>'notes'
		,-query		=>{-keyord=>'-dall', -key=>{'idrm'=>undef}, -order=>'utime desc'}
		#,-qfilter	=>sub{!$_[4]->{'idrm'}}
		}
	,'gwohier'	=>{
		 -lbl		=>'Organizer hierarchy'
		,-cmt		=>'Groupware organizer hierarchy'
		,-table		=>'gwo'
		,-query		=>{-keyord=>'-dall', -key=>{'idrm'=>undef}, -order=>'etime desc'}
		}
	,'gwoobj'	=>{
		 -lbl		=>'Organizer objects'
		,-cmt		=>'Groupware organizer objects'
		,-table		=>'gwo'
		,-query		=>{-data	=>['object']
				  ,-display	=>['object']
				  ,-order	=>'object'
				  ,-group	=>'object'
				  ,-keyord	=>'-aall'
					}
		,-qhref		=>{-key=>['object'], -form=>'gwo', -cmd=>'recList'}
		}
	,$w->{-setall}
	?('gwodoc'	=>{
		 -lbl		=>'Organizer doctypes'
		,-cmt		=>'Groupware organizer document types'
		,-table		=>'gwo'
		,-query		=>{-data	=>['doctype']
				  ,-display	=>['doctype']
				  ,-order	=>'doctype'
				  ,-group	=>'doctype'
				  ,-keyord	=>'-aall'
					}
		,-qhref		=>{-key=>['doctype'], -form=>'gwo', -cmd=>'recList'}
		})
	: ()
	,$w->{-setall}
	?('gwoprj'	=>{
		 -lbl		=>'Organizer projects'
		,-cmt		=>'Groupware organizer projects'
		,-table		=>'gwo'
		,-query		=>{-data	=>['project']
				  ,-display	=>['project']
				  ,-order	=>'project'
				  ,-group	=>'project'
				  ,-keyord	=>'-aall'
					}
		,-qhref		=>{-key=>['project'], -form=>'gwo', -cmd=>'recList'}
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
