#standardSQL
SELECT
ndt.log_time AS log_time,
8 * (ndt.web100_log_entry.snap.HCThruOctetsAcked /
(ndt.web100_log_entry.snap.SndLimTimeRwin +
ndt.web100_log_entry.snap.SndLimTimeCwnd +
ndt.web100_log_entry.snap.SndLimTimeSnd)) AS download_speed_Mbps,
ndt.web100_log_entry.snap.MinRTT AS minRTT,
ndt.web100_log_entry.snap.MaxRTT AS maxRTT,
mm.asn_number AS asn_number,
mm.asn_name AS asn_name,
ndt.connection_spec.client_ip AS client_ip,
ndt.connection_spec.client_geolocation.latitude AS client_lat,
ndt.connection_spec.client_geolocation.longitude AS client_lon,
ndt.connection_spec.client_geolocation.area_code AS client_area_code,
ndt.connection_spec.client_geolocation.city AS client_city,
ndt.connection_spec.client_geolocation.continent_code AS client_continent_code,
ndt.connection_spec.client_geolocation.country_code AS client_country_code,
ndt.connection_spec.client_geolocation.country_code3 AS client_country_code3,
ndt.connection_spec.client_geolocation.country_name AS client_country_name,
ndt.connection_spec.client_geolocation.metro_code AS client_metro_code,
ndt.connection_spec.client_geolocation.postal_code AS client_postal_code,
ndt.connection_spec.client_geolocation.region AS client_region,
ndt.test_id AS test_id,
ndt.partition_date AS partition_date,
ndt.project AS project,
ndt.log_time AS log_time,
ndt.task_filename AS task_filename,
ndt.parse_time AS parse_time,
ndt.blacklist_flags AS blacklist_flags,
ndt.connection_spec.client_af AS client_af,
ndt.connection_spec.client_application AS client_application,
ndt.connection_spec.client_browser AS client_browser,
ndt.connection_spec.client_hostname AS client_hostname,
ndt.connection_spec.client_os AS client_os,
ndt.connection_spec.client_kernel_version AS client_kernel_version,
ndt.connection_spec.client_version AS client_version,
ndt.connection_spec.server_af AS server_af,
ndt.connection_spec.server_hostname AS server_hostname,
ndt.connection_spec.server_ip AS server_ip,
ndt.connection_spec.server_kernel_version AS server_kernel_version,
ndt.connection_spec.server_geolocation.area_code AS server_area_code,
ndt.connection_spec.server_geolocation.city AS server_city,
ndt.connection_spec.server_geolocation.continent_code AS server_continent_code,
ndt.connection_spec.server_geolocation.country_code AS server_country_code,
ndt.connection_spec.server_geolocation.country_code3 AS server_country_code3,
ndt.connection_spec.server_geolocation.country_name AS server_country_name,
ndt.connection_spec.server_geolocation.latitude AS server_latitude,
ndt.connection_spec.server_geolocation.longitude AS server_longitude,
ndt.connection_spec.server_geolocation.metro_code AS server_metro_code,
ndt.connection_spec.server_geolocation.postal_code AS server_postal_code,
ndt.connection_spec.server_geolocation.region AS server_region,
ndt.anomalies.no_meta AS anomalies_no_meta,
ndt.anomalies.snaplog_error AS anomalies_snaplog_error,
ndt.anomalies.num_snaps AS anomalies_num_snaps,
ndt.anomalies.blacklist_flags AS anomalies_blacklist_flags,
ndt.connection_spec.data_direction AS data_direction,
ndt.connection_spec.tls AS tls,
ndt.connection_spec.websockets AS websockets,
ndt.web100_log_entry.version AS web100_log_entry_version,
ndt.web100_log_entry.log_time AS web100_log_entry_log_time,
ndt.web100_log_entry.group_name AS web100_log_entry_group_name,
ndt.web100_log_entry.connection_spec.local_af AS web100_log_entry_local_af,
ndt.web100_log_entry.connection_spec.local_ip AS web100_log_entry_local_ip,
ndt.web100_log_entry.connection_spec.local_port AS web100_log_entry_local_port,
ndt.web100_log_entry.connection_spec.remote_ip AS web100_log_entry_remote_ip,
ndt.web100_log_entry.connection_spec.remote_port AS web100_log_entry_remote_port,
ndt.web100_log_entry.snap.AbruptTimeouts AS web100_log_entry_snap_AbruptTimeouts,
ndt.web100_log_entry.snap.ActiveOpen AS web100_log_entry_snap_ActiveOpen,
ndt.web100_log_entry.snap.CERcvd AS web100_log_entry_snap_CERcvd,
ndt.web100_log_entry.snap.CongAvoid AS web100_log_entry_snap_CongAvoid,
ndt.web100_log_entry.snap.CongOverCount AS web100_log_entry_snap_CongOverCount,
ndt.web100_log_entry.snap.CongSignals AS web100_log_entry_snap_CongSignals,
ndt.web100_log_entry.snap.CountRTT AS web100_log_entry_snap_CountRTT,
ndt.web100_log_entry.snap.CurAppRQueue AS web100_log_entry_snap_CurAppRQueue,
ndt.web100_log_entry.snap.CurAppWQueue AS web100_log_entry_snap_CurAppWQueue,
ndt.web100_log_entry.snap.CurCwnd AS web100_log_entry_snap_CurCwnd,
ndt.web100_log_entry.snap.CurMSS AS web100_log_entry_snap_CurMSS,
ndt.web100_log_entry.snap.CurRTO AS web100_log_entry_snap_CurRTO,
ndt.web100_log_entry.snap.CurReasmQueue AS web100_log_entry_snap_CurReasmQueue,
ndt.web100_log_entry.snap.CurRetxQueue AS web100_log_entry_snap_CurRetxQueue,
ndt.web100_log_entry.snap.CurRwinRcvd AS web100_log_entry_snap_CurRwinRcvd,
ndt.web100_log_entry.snap.CurRwinSent AS web100_log_entry_snap_CurRwinSent,
ndt.web100_log_entry.snap.CurSsthresh AS web100_log_entry_snap_CurSsthresh,
ndt.web100_log_entry.snap.CurTimeoutCount AS web100_log_entry_snap_CurTimeoutCount,
ndt.web100_log_entry.snap.DSACKDups AS web100_log_entry_snap_DSACKDups,
ndt.web100_log_entry.snap.DataSegsIn AS web100_log_entry_snap_DataSegsIn,
ndt.web100_log_entry.snap.DataSegsOut AS web100_log_entry_snap_DataSegsOut,
ndt.web100_log_entry.snap.DupAcksIn AS web100_log_entry_snap_DupAcksIn,
ndt.web100_log_entry.snap.DupAcksOut AS web100_log_entry_snap_DupAcksOut,
ndt.web100_log_entry.snap.Duration AS web100_log_entry_snap_Duration,
ndt.web100_log_entry.snap.ECN AS web100_log_entry_snap_ECN,
ndt.web100_log_entry.snap.FastRetran AS web100_log_entry_snap_FastRetran,
ndt.web100_log_entry.snap.HCDataOctetsIn AS web100_log_entry_snap_HCDataOctetsIn,
ndt.web100_log_entry.snap.HCDataOctetsOut AS web100_log_entry_snap_HCDataOctetsOut,
ndt.web100_log_entry.snap.HCThruOctetsAcked AS web100_log_entry_snap_HCThruOctetsAcked,
ndt.web100_log_entry.snap.HCThruOctetsReceived AS web100_log_entry_snap_HCThruOctetsReceived,
ndt.web100_log_entry.snap.LimCwnd AS web100_log_entry_snap_LimCwnd,
ndt.web100_log_entry.snap.LimRwin AS web100_log_entry_snap_LimRwin,
ndt.web100_log_entry.snap.LocalAddress AS web100_log_entry_snap_LocalAddress,
ndt.web100_log_entry.snap.LocalAddressType AS web100_log_entry_snap_LocalAddressType,
ndt.web100_log_entry.snap.LocalPort AS web100_log_entry_snap_LocalPort,
ndt.web100_log_entry.snap.MSSRcvd AS web100_log_entry_snap_MSSRcvd,
ndt.web100_log_entry.snap.MaxAppRQueue AS web100_log_entry_snap_MaxAppRQueue,
ndt.web100_log_entry.snap.MaxAppWQueue AS web100_log_entry_snap_MaxAppWQueue,
ndt.web100_log_entry.snap.MaxMSS AS web100_log_entry_snap_MaxMSS,
ndt.web100_log_entry.snap.MaxRTO AS web100_log_entry_snap_MaxRTO,
ndt.web100_log_entry.snap.MaxRTT AS web100_log_entry_snap_MaxRTT,
ndt.web100_log_entry.snap.MaxReasmQueue AS web100_log_entry_snap_MaxReasmQueue,
ndt.web100_log_entry.snap.MaxRetxQueue AS web100_log_entry_snap_MaxRetxQueue,
ndt.web100_log_entry.snap.MaxRwinRcvd AS web100_log_entry_snap_MaxRwinRcvd,
ndt.web100_log_entry.snap.MaxRwinSent AS web100_log_entry_snap_MaxRwinSent,
ndt.web100_log_entry.snap.MaxSsCwnd AS web100_log_entry_snap_MaxSsCwnd,
ndt.web100_log_entry.snap.MaxSsthresh AS web100_log_entry_snap_MaxSsthresh,
ndt.web100_log_entry.snap.MinMSS AS web100_log_entry_snap_MinMSS,
ndt.web100_log_entry.snap.MinRTO AS web100_log_entry_snap_MinRTO,
ndt.web100_log_entry.snap.MinRTT AS web100_log_entry_snap_MinRTT,
ndt.web100_log_entry.snap.MinRwinRcvd AS web100_log_entry_snap_MinRwinRcvd,
ndt.web100_log_entry.snap.MinRwinSent AS web100_log_entry_snap_MinRwinSent,
ndt.web100_log_entry.snap.MinSsthresh AS web100_log_entry_snap_MinSsthresh,
ndt.web100_log_entry.snap.Nagle AS web100_log_entry_snap_Nagle,
ndt.web100_log_entry.snap.NonRecovDA AS web100_log_entry_snap_NonRecovDA,
ndt.web100_log_entry.snap.OctetsRetrans AS web100_log_entry_snap_OctetsRetrans,
ndt.web100_log_entry.snap.OtherReductions AS web100_log_entry_snap_OtherReductions,
ndt.web100_log_entry.snap.PostCongCountRTT AS web100_log_entry_snap_PostCongCountRTT,
ndt.web100_log_entry.snap.PostCongSumRTT AS web100_log_entry_snap_PostCongSumRTT,
ndt.web100_log_entry.snap.PreCongSumCwnd AS web100_log_entry_snap_PreCongSumCwnd,
ndt.web100_log_entry.snap.PreCongSumRTT AS web100_log_entry_snap_PreCongSumRTT,
ndt.web100_log_entry.snap.QuenchRcvd AS web100_log_entry_snap_QuenchRcvd,
ndt.web100_log_entry.snap.RTTVar AS web100_log_entry_snap_RTTVar,
ndt.web100_log_entry.snap.RcvNxt AS web100_log_entry_snap_RcvNxt,
ndt.web100_log_entry.snap.RcvRTT AS web100_log_entry_snap_RcvRTT,
ndt.web100_log_entry.snap.RcvWindScale AS web100_log_entry_snap_RcvWindScale,
ndt.web100_log_entry.snap.RecInitial AS web100_log_entry_snap_RecInitial,
ndt.web100_log_entry.snap.RemAddress AS web100_log_entry_snap_RemAddress,
ndt.web100_log_entry.snap.RemPort AS web100_log_entry_snap_RemPort,
ndt.web100_log_entry.snap.RetranThresh AS web100_log_entry_snap_RetranThresh,
ndt.web100_log_entry.snap.SACK AS web100_log_entry_snap_SACK,
ndt.web100_log_entry.snap.SACKBlocksRcvd AS web100_log_entry_snap_SACKBlocksRcvd,
ndt.web100_log_entry.snap.SACKsRcvd AS web100_log_entry_snap_SACKsRcvd,
ndt.web100_log_entry.snap.SampleRTT AS web100_log_entry_snap_SampleRTT,
ndt.web100_log_entry.snap.SegsIn AS web100_log_entry_snap_SegsIn,
ndt.web100_log_entry.snap.SegsOut AS web100_log_entry_snap_SegsOut,
ndt.web100_log_entry.snap.SegsRetrans AS web100_log_entry_snap_SegsRetrans,
ndt.web100_log_entry.snap.SendStall AS web100_log_entry_snap_SendStall,
ndt.web100_log_entry.snap.SlowStart AS web100_log_entry_snap_SlowStart,
ndt.web100_log_entry.snap.SmoothedRTT AS web100_log_entry_snap_SmoothedRTT,
ndt.web100_log_entry.snap.SndInitial AS web100_log_entry_snap_SndInitial,
ndt.web100_log_entry.snap.SndLimBytesCwnd AS web100_log_entry_snap_SndLimBytesCwnd,
ndt.web100_log_entry.snap.SndLimBytesRwin AS web100_log_entry_snap_SndLimBytesRwin,
ndt.web100_log_entry.snap.SndLimBytesSender AS web100_log_entry_snap_SndLimBytesSender,
ndt.web100_log_entry.snap.SndLimTimeCwnd AS web100_log_entry_snap_SndLimTimeCwnd,
ndt.web100_log_entry.snap.SndLimTimeRwin AS web100_log_entry_snap_SndLimTimeRwin,
ndt.web100_log_entry.snap.SndLimTimeSnd AS web100_log_entry_snap_SndLimTimeSnd,
ndt.web100_log_entry.snap.SndLimTransCwnd AS web100_log_entry_snap_SndLimTransCwnd,
ndt.web100_log_entry.snap.SndLimTransRwin AS web100_log_entry_snap_SndLimTransRwin,
ndt.web100_log_entry.snap.SndLimTransSnd AS web100_log_entry_snap_SndLimTransSnd,
ndt.web100_log_entry.snap.SndMax AS web100_log_entry_snap_SndMax,
ndt.web100_log_entry.snap.SndNxt AS web100_log_entry_snap_SndNxt,
ndt.web100_log_entry.snap.SndUna AS web100_log_entry_snap_SndUna,
ndt.web100_log_entry.snap.SndWindScale AS web100_log_entry_snap_SndWindScale,
ndt.web100_log_entry.snap.SpuriousFrDetected AS web100_log_entry_snap_SpuriousFrDetected,
ndt.web100_log_entry.snap.StartTimeStamp AS web100_log_entry_snap_StartTimeStamp,
ndt.web100_log_entry.snap.State AS web100_log_entry_snap_State,
ndt.web100_log_entry.snap.SubsequentTimeouts AS web100_log_entry_snap_SubsequentTimeouts,
ndt.web100_log_entry.snap.SumRTT AS web100_log_entry_snap_SumRTT,
ndt.web100_log_entry.snap.TimeStamps AS web100_log_entry_snap_TimeStamps,
ndt.web100_log_entry.snap.Timeouts AS web100_log_entry_snap_Timeouts,
ndt.web100_log_entry.snap.WinScaleRcvd AS web100_log_entry_snap_WinScaleRcvd,
ndt.web100_log_entry.snap.WinScaleSent AS web100_log_entry_snap_WinScaleSent,
ndt.web100_log_entry.snap.X_OtherReductionsCM AS web100_log_entry_snap_X_OtherReductionsCM,
ndt.web100_log_entry.snap.X_OtherReductionsCV AS web100_log_entry_snap_X_OtherReductionsCV,
ndt.web100_log_entry.snap.X_Rcvbuf AS web100_log_entry_snap_X_Rcvbuf,
ndt.web100_log_entry.snap.X_Sndbuf AS web100_log_entry_snap_X_Sndbuf,
ndt.web100_log_entry.snap.X_dbg1 AS web100_log_entry_snap_X_dbg1,
ndt.web100_log_entry.snap.X_dbg2 AS web100_log_entry_snap_X_dbg2,
ndt.web100_log_entry.snap.X_dbg3 AS web100_log_entry_snap_X_dbg3,
ndt.web100_log_entry.snap.X_dbg4 AS web100_log_entry_snap_X_dbg4,
ndt.web100_log_entry.snap.X_rcv_ssthresh AS web100_log_entry_snap_X_rcv_ssthresh,
ndt.web100_log_entry.snap.X_wnd_clamp AS web100_log_entry_snap_X_wnd_clamp
FROM
`measurement-lab.release.ndt_downloads` AS ndt,
`measurement-lab.maxmind_historical.DATEMM` AS mm
WHERE
ndt.partition_date BETWEEN DATE1 AND DATE2
AND
(
  ndt.connection_spec.client_geolocation.region = REGION
  OR ndt.connection_spec.client_geolocation.region = REGIONCODE
)
AND ndt.partition_date BETWEEN DATE1 AND DATE2
AND 
TO_BASE64(NET.IP_FROM_STRING(ndt.connection_spec.client_ip)) 
BETWEEN 
TO_BASE64(NET.IP_FROM_STRING(mm.min_ip)) AND
TO_BASE64(NET.IP_FROM_STRING(mm.max_ip));