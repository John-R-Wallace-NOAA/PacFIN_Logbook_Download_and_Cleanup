

PacFIN.Logbook.Data.by.Year <- function(Year = 1981, stringsAsCharacter = T, dsn="PacFIN", uid="wallacej", pwd=PacFIN.PW) {

  require(Hmisc)

  import.sql <- function(SQL, VAR="", VAL="", File = F, dsn, uid, pwd, View.Parsed.Only = F)
  {

     # Example using SQL without an external file:
     #   import.sql("Select * from pacfin.bds_sp where rownum < 11", dsn="PacFIN", uid=<User ID>, pwd=<password>)

        require(RODBC)
        require(Hmisc)

        if(File) {
                SQL.Parsed <- sedit(paste(scan(SQL, what = " ", quote = NULL, quiet = T), collapse = " "), VAR, VAL)
                if(View.Parsed.Only) {
                        printf(SQL.Parsed)
                        return(invisible())
                }
        }
        else SQL.Parsed <- sedit(SQL, VAR, VAL)

        SQL.Parsed <- sedit(SQL, VAR, VAL)

        CON <- odbcConnect(dsn, uid = uid, pwd = pwd)
	on.exit(odbcClose(CON))

        sqlQuery(CON, query = SQL.Parsed)
  }

 # Get logbook data

   Logbook.sql <- "select  TR.TRIP_ID,
      tr.agid, 
      to_char(tr.dday,'DD-MON-YYYY') DDate,
      tr.dtime,
      to_char(tr.dday, 'DD') DDay,
      dmonth,
      dyear, 
      dport, 
      p2.pcid dpcid, 
      to_char(tr.rday,'DD-MON-YYYY') RDate,
      tr.rtime,
      to_char(tr.rday, 'DD') RDay,
      tr.rmonth,
      tr.ryear, 
      tr.rday,
      rport, 
      p1.pcid rpcid, 
      tr.drvid,           
      to_char(tow_date,'DD-MON-YYYY') towdate, 
      tw.townum, 
      area, 
      arid_psmfc, 
      block, 
      block_or, 
      latlong_type, 
      ch_lat, 
      ch_long, 
      msec_lat, 
      msec_long, 
      set_lat, 
      set_long, 
      set_time, 
      up_time, 
      duration,  
      up_area, 
      up_arid_psmfc, 
      up_block, 
      up_block_or, 
      up_ch_lat, 
      up_ch_long, 
      up_msec_lat, 
      up_msec_long, 
      up_lat, 
      up_long, 
      tw.net_type,   
      grid,           
      depth_type1, 
      depth1, 
      depth_type2, 
      depth2, 
      target, 
      pacfin_target, 
      ps_grnd_code,  
      spid,  
      hpounds, 
      apounds, 
      apounds_calculated, 
      apounds_wdfw, 
      adj_towtime, 
      c.source catchsource, 
      c.spcode, 
      ft_match_flag, 
      lbkutil.lbk_ftid_list(TR.TRIP_ID) ftid,
      NULL ticket_date, 
      NULL ftsource, 
      tr.warning tripwarning, 
      tw.warning towwarning, 
      c.warning catchwarning,
      permid_1,
      permid_2,
      permid_3,
      permid_4,
      permid_5,
      case when gr_endor_1||gr_endor_2||gr_endor_3||gr_endor_4||gr_endor_5 like '%T%' 
            and gr_endor_1||gr_endor_2||gr_endor_3||gr_endor_4||gr_endor_5 not like '%L%' 
            and gr_endor_1||gr_endor_2||gr_endor_3||gr_endor_4||gr_endor_5 not like '%P%' 
           then 'TRAWL'
           when (gr_endor_1||gr_endor_2||gr_endor_3||gr_endor_4||gr_endor_5 like '%L%' 
              or gr_endor_1||gr_endor_2||gr_endor_3||gr_endor_4||gr_endor_5 like '%P%') 
             and gr_endor_1||gr_endor_2||gr_endor_3||gr_endor_4||gr_endor_5 not like '%T%' then 'FIXED'
           else decode(prmt.permid_1,null,null,'BOTH')
           end gr_sector,
      gr_endor_1,
      gr_endor_2,
      gr_endor_3,
      gr_endor_4,
      gr_endor_5,
      sable_tier_1,
      sable_tier_2,
      sable_tier_3,
      sable_tier_4,
      sable_tier_5,
      len_endor_1,
      len_endor_2,
      len_endor_3,
      len_endor_4,
      len_endor_5
 from pacfin.lbk_trip tr, pacfin.lbk_tow tw, pacfin.lbk_catch c, pacfin.lbk_sp s,
      pacfin.asp, pacfin.lbk_gr g, pacfin.lbk_pr p1, pacfin.lbk_pr p2, 
      pacfin.lbkprmtlst prmt
 where tr.ryear = '&year'
   and p1.agid(+) = tr.agid  
   and p1.lbk_port(+) = tr.rport
   and p2.agid(+) = tr.agid  
   and p2.lbk_port(+) = tr.dport
   and TR.TRIP_ID = tw.trip_id
   and tw.agid = g.agid(+) 
   and tw.net_type = g.net_type(+)
   and tw.trip_id = c.trip_id 
   and tw.townum = c.townum
   and c.spcode = s.lbk_spcode(+) 
   and c.agid = s.agid(+)
   and s.agid = asp.agid(+) 
   and s.category = asp.category(+)
   and nvl(prmt.ryear, &year) = &year
   and tw.trip_id = prmt.trip_id(+)
 order by tow_date, drvid, TR.TRIP_ID, tw.townum, spid"
   

 cat("\nGet logbook data for", Year, "\b:", date(), "\n\n"); flush.console()
 
 import.sql(Logbook.sql, "&year", Year, uid = uid, pwd = pwd, dsn = dsn)
 
   
}


