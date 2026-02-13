SHELL := /bin/bash

whisperx:
	mv .venv-whisperx .venv-whisperx-old || true
	rm -rf .venv-whisperx-old &
	uv venv .venv-whisperx --system-site-packages

	@ln -sf $(PWD)/ffmpeg-static/ffmpeg .venv-whisperx/bin/ffmpeg
	@ln -sf $(PWD)/ffmpeg-static/ffprobe .venv-whisperx/bin/ffprobe
	@echo "✅ FFmpeg linked into virtual environment."

	uv pip compile requirements-whisperx-topdeps.txt -o requirements-whisperx-subdeps.txt --no-deps
	sed -i '/^torch==/d' requirements-whisperx-subdeps.txt
	sed -i '/^torchaudio==/d' requirements-whisperx-subdeps.txt

	source .venv-whisperx/bin/activate && \
	uv pip install --no-deps --no-build-isolation git+https://github.com/pytorch/audio.git@release/2.4 && \
	uv pip install --no-deps -r requirements-whisperx-subdeps.txt && \
	uv pip install -r requirements-whisperx.txt --no-build-isolation && \
	python -c "import torch; print(f'PyTorch Version: {torch.__version__}'); print(f'CUDA Available: {torch.cuda.is_available()}'); print(f'CUDA Version: {torch.version.cuda}'); import torchaudio; print(f'torchaudio Version: {torchaudio.__version__}')"
	
	# Building ctranslate2
# 	source .venv-whisperx/bin/activate && \
# 	if [ ! -d "CTranslate2" ]; then \
# 		git clone --recursive https://github.com/OpenNMT/CTranslate2.git; \
# 	fi && \
# 	cd CTranslate2 && git checkout v4.3.1 && \
# 	rm -rf build && mkdir -p build && cd build && \
# 	cmake .. -DCMAKE_INSTALL_PREFIX=$(PWD)/.venv-whisperx \
# 		-DWITH_CUDA=ON -DWITH_CUDNN=ON -DWITH_MKL=OFF -DOPENMP_RUNTIME=COMP \
# 		-DCUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda && \
# 	make -j$$(nproc) && make install

	source .venv-whisperx/bin/activate && \
	uv pip uninstall ctranslate2 || true && \
	cd CTranslate2/build && \
	make install && \
    cd ../python && \
    export CTRANSLATE2_ROOT=$(PWD)/.venv-whisperx && \
    uv pip install . --verbose --no-build-isolation

	echo 'export LD_LIBRARY_PATH="$$VIRTUAL_ENV/lib:$$VIRTUAL_ENV/lib64:$$LD_LIBRARY_PATH"' >> .venv-whisperx/bin/activate

	source .venv-whisperx/bin/activate && \
	python -c "import ctranslate2; print(f'CTranslate2 CUDA : {ctranslate2.__version__}')"