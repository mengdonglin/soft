#
# Topology for generic Apollolake board with no codec.
#

# Include topology builder
include(`utils.m4')
include(`dai.m4')
include(`hda.m4')
include(`ssp.m4')
include(`pipeline.m4')

# Include TLV library
include(`common/tlv.m4')

# Include Token library
include(`sof/tokens.m4')

# Include Apollolake DSP configuration
include(`platform/intel/bxt.m4')

#
# Define the pipelines
#
# PCM0 ----> volume -----> iDisp1
# PCM1 ----> Volume -----> iDisp2
# PCM2 ----> volume -----> iDisp3
# PCM3 ----> volume -----> Analog Codec DAI
#      <---- volume <----- Analog Codec DAI
# PCM4 ----> volume -----> Digital Codec DAI
#      <---- volume <----- Digital Codec DAI



dnl PIPELINE_PCM_ADD(pipeline,
dnl     pipe id, pcm, max channels, format,
dnl     frames, deadline, priority, core)

# Low Latency playback pipeline 1 on PCM 0 using max 2 channels of s16le.
# Schedule 48 frames per 1000us deadline on core 0 with priority 0
PIPELINE_PCM_ADD(sof/pipe-volume-playback.m4,
	1, 0, 2, s16le,
	48, 1000, 0, 0)

# Low Latency playback pipeline 2 on PCM 1 using max 2 channels of s16le.
# Schedule 48 frames per 1000us deadline on core 0 with priority 0
PIPELINE_PCM_ADD(sof/pipe-volume-playback.m4,
	2, 1, 2, s16le,
	48, 1000, 0, 0)

# Low Latency playback pipeline 3 on PCM 2 using max 2 channels of s16le.
# Schedule 48 frames per 1000us deadline on core 0 with priority 0
PIPELINE_PCM_ADD(sof/pipe-volume-playback.m4,
	3, 2, 2, s16le,
	48, 1000, 0, 0)

# Low Latency playback pipeline 4 on PCM 3 using max 2 channels of s16le.
# Schedule 48 frames per 1000us deadline on core 0 with priority 0
PIPELINE_PCM_ADD(sof/pipe-volume-playback.m4,
        4, 3, 2, s16le,
        48, 1000, 0, 0)

# Low Latency capture pipeline 5 on PCM 3 using max 2 channels of s16le.
# Schedule 48 frames per 1000us deadline on core 0 with priority 0
PIPELINE_PCM_ADD(sof/pipe-volume-capture.m4,
        5, 3, 2, s16le,
        48, 1000, 0, 0)

# Low Latency playback pipeline 6 on PCM 4 using max 2 channels of s16le.
# Schedule 48 frames per 1000us deadline on core 0 with priority 0
PIPELINE_PCM_ADD(sof/pipe-volume-playback.m4,
        6, 4, 2, s16le,
        48, 1000, 0, 0)

# Low Latency capture pipeline 7 on PCM 4 using max 2 channels of s16le.
# Schedule 48 frames per 1000us deadline on core 0 with priority 0
PIPELINE_PCM_ADD(sof/pipe-volume-capture.m4,
        7, 4, 2, s16le,
        48, 1000, 0, 0)

#
# DAIs configuration
#

dnl DAI_ADD(pipeline,
dnl     pipe id, dai type, dai_index, dai_be,
dnl     buffer, periods, format,
dnl     frames, deadline, priority, core)

# playback DAI is iDisp1 using 2 periods
# Buffers use s16le format, with 48 frame per 1000us on core 0 with priority 0
DAI_ADD(sof/pipe-dai-playback.m4,
	1, HDA, 0, iDisp1,
	PIPELINE_SOURCE_1, 2, s16le,
	48, 1000, 0, 0)

# playback DAI is iDisp2 using 2 periods
# Buffers use s16le format, with 48 frame per 1000us on core 0 with priority 0
DAI_ADD(sof/pipe-dai-playback.m4,
	2, HDA, 1, iDisp2,
	PIPELINE_SOURCE_2, 2, s16le,
	48, 1000, 0, 0)

# playback DAI is iDisp3 using 2 periods
# Buffers use s16le format, with 48 frame per 1000us on core 0 with priority 0
DAI_ADD(sof/pipe-dai-playback.m4,
	3, HDA, 2, iDisp3,
	PIPELINE_SOURCE_3, 2, s16le,
	48, 1000, 0, 0)

# playback DAI is Analog using 2 periods
# Buffers use s16le format, with 48 frame per 1000us on core 0 with priority 0
DAI_ADD(sof/pipe-dai-playback.m4,
        4, HDA, 3, Analog Playback and Capture,
        PIPELINE_SOURCE_4, 2, s16le,
        48, 1000, 0, 0)

# capture DAI is Analog using 2 periods
# Buffers use s16le format, with 48 frame per 1000us on core 0 with priority 0
DAI_ADD(sof/pipe-dai-capture.m4,
        5, HDA, 3, Analog Playback and Capture,
        PIPELINE_SINK_5, 2, s16le,
        48, 1000, 0, 0)


# playback DAI is Digital using 2 periods
# Buffers use s16le format, with 48 frame per 1000us on core 0 with priority 0
DAI_ADD(sof/pipe-dai-playback.m4,
        6, HDA, 4, Digital Playback and Capture,
        PIPELINE_SOURCE_6, 2, s16le,
        48, 1000, 0, 0)

# capture DAI is Digital using 2 periods
# Buffers use s16le format, with 48 frame per 1000us on core 0 with priority 0
DAI_ADD(sof/pipe-dai-capture.m4,
        7, HDA, 4, Digital Playback and Capture,
        PIPELINE_SINK_7, 2, s16le,
        48, 1000, 0, 0)

dnl PCM_PLAYBACK_ADD(name, pcm_id, playback)
PCM_PLAYBACK_ADD(HDMI1, 0, PIPELINE_PCM_1)
PCM_PLAYBACK_ADD(HDMI2, 1, PIPELINE_PCM_2)
PCM_PLAYBACK_ADD(HDMI3, 2, PIPELINE_PCM_3)
PCM_DUPLEX_ADD(Analog,  3, PIPELINE_PCM_4, PIPELINE_PCM_5)
PCM_DUPLEX_ADD(Digital, 4, PIPELINE_PCM_6, PIPELINE_PCM_7)

#
# BE configurations - overrides config in ACPI if present
#

dnl HDA_DAI_CONFIG(dai_index, link_id, name)
HDA_DAI_CONFIG(0, 1, iDisp1)
HDA_DAI_CONFIG(1, 2, iDisp2)
HDA_DAI_CONFIG(2, 3, iDisp3)
HDA_DAI_CONFIG(3, 4, Analog Playback and Capture)
HDA_DAI_CONFIG(4, 5, Digital Playback and Capture)
