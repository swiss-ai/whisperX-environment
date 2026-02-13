import whisperx

device = "cuda" 
audio_file = "sample_0001_original.wav"
compute_type = "float16"

# transcribe with original whisper
model = whisperx.load_model("large", device, compute_type=compute_type, language="en")
result = model.transcribe(audio_file)

print("Before alignment")
print(result["segments"]) 
print(result["language"])

# load alignment model and metadata
model_a, metadata = whisperx.load_align_model(language_code=result["language"], device=device)

# align whisper output
result_aligned = whisperx.align(result["segments"], model_a, metadata, audio_file, device)

print("After alignment")
print(result_aligned["segments"]) # after alignment
print(result_aligned["word_segments"]) # after alignment