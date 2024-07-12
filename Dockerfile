FROM python:3.11

# create new user
RUN useradd --create-home user
RUN mkdir /home/user/inverter-connect
WORKDIR /home/user/inverter-connect
COPY . .

# create and activate virtual environment
RUN /usr/local/bin/python --version
RUN /usr/local/bin/python -m venv .venv-app
ENV PATH="/home/user/inverter-connect/.venv-app/bin:$PATH"

# install requirements
COPY requirements.txt .
RUN pip install --no-cache-dir wheel
RUN pip install --no-cache-dir -r requirements.txt

# install config
RUN mkdir -p /home/user/.config/inverter-connect
COPY cfg/inverter-connect.toml /home/user/.config/inverter-connect/inverter-connect.toml

# change ownership
RUN chown -R user:user /home/user/.config/inverter-connect
RUN chown -R user:user /home/user/inverter-connect

# change to user
USER user

# make sure all messages always reach console
#ENV PYTHONUNBUFFERED=1

# activate virtual environment
#ENV VIRTUAL_ENV=/home/user/inverter-connect/.venv-app
#ENV PATH="/home/user/inverter-connect/.venv-app/bin:$PATH"

RUN ./cli.py --help

#CMD ["/bin/bash"]
#CMD ["./cli.py", "publish-loop", ">/dev/null"]
CMD ["./cli.py", "publish-loop"]
